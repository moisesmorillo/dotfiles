#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
REPO_SETTINGS="${PI_REPO_SETTINGS:-$ROOT_DIR/pi/.pi/agent/settings.json}"
INSTALLED_SETTINGS="${PI_SETTINGS_FILE:-$HOME/.pi/agent/settings.json}"

if ! command -v jq >/dev/null 2>&1; then
	echo "pi-status: jq is required" >&2
	exit 1
fi
for file in "$REPO_SETTINGS" "$INSTALLED_SETTINGS"; do
	if [ ! -f "$file" ]; then
		echo "pi-status: settings file not found: $file" >&2
		exit 1
	fi
	jq -e 'type == "object"' "$file" >/dev/null || {
		echo "pi-status: settings must be a JSON object: $file" >&2
		exit 1
	}
done

DRIFT="$(jq -n -r --slurpfile desired "$REPO_SETTINGS" --slurpfile installed "$INSTALLED_SETTINGS" '
	def package_source:
		if type == "string" then .
		elif type == "object" and (.source | type) == "string" then .source
		else error("package entry must be a string or an object with a string source")
		end;
	def package_id($spec):
		if ($spec | startswith("npm:")) then
			($spec | sub("^npm:"; "")) as $body |
			if ($body | startswith("@")) then
				if ($body | test("^@[^/]+/[^@]+@.+$")) then
					($body | capture("^(?<name>@[^/]+/[^@]+)@(?<version>.+)$")) as $parts |
					{name: ("npm:" + $parts.name), version: $parts.version}
				else {name: ("npm:" + $body), version: ""} end
			else
				if ($body | test("^[^@]+@.+$")) then
					($body | capture("^(?<name>[^@]+)@(?<version>.+)$")) as $parts |
					{name: ("npm:" + $parts.name), version: $parts.version}
				else {name: ("npm:" + $body), version: ""} end
			end
		elif ($spec | startswith("git:")) then
			if ($spec | test("^git:.+@.+$")) then
				($spec | capture("^(?<name>git:.+)@(?<version>.+)$")) as $parts |
				{name: $parts.name, version: $parts.version}
			else {name: $spec, version: ""} end
		else {name: $spec, version: ""} end;
	($desired[0].packages // [] | map(package_source)) as $wanted |
	($installed[0].packages // [] | map(package_source)) as $actual |
	[$wanted[] as $item | package_id($item) as $id |
		([$actual[] | select((package_id(.)).name == $id.name)]) as $matches |
		if ($actual | index($item)) != null then empty
		elif ($matches | length) > 0 then
			"version-mismatch: \($item) (installed: \($matches | join(", ")))"
		else "missing: \($item)" end
	] as $wantedDrift |
	[$actual | to_entries[] | .key as $index | .value as $item |
		([$wanted[] | select(. == $item)] | length) as $wantedCount |
		([$actual[0:($index + 1)][] | select(. == $item)] | length) as $actualCount |
		select($actualCount > $wantedCount) |
		"extra: \($item)"
	] as $extraDrift |
	$wantedDrift[], $extraDrift[]
')"

if [ -n "$DRIFT" ]; then
	printf '%s\n' "$DRIFT"
	exit 1
fi

echo "Pi package declarations match the repository settings."
