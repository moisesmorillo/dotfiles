#!/usr/bin/env bash
# Shared helpers for the Pi package scripts. Source this file; do not execute it.

# Print the on-disk location Pi uses for a package source, or nothing when the
# source kind has no predictable location (for example a local path).
#   npm:@scope/name@1.2.3 -> $PI_AGENT_DIR/npm/node_modules/@scope/name
#   git:github.com/o/r@ref -> $PI_AGENT_DIR/git/github.com/o/r
pi_package_path() {
	local spec="$1" agent_dir="$2" body name ref
	case "$spec" in
	npm:*)
		body="${spec#npm:}"
		if [ "${body#@}" != "$body" ]; then
			# Scoped: a second "@" separates the version.
			name="${body#@}"
			case "$name" in
			*@*) name="@${name%@*}" ;;
			*) name="$body" ;;
			esac
		else
			name="${body%@*}"
		fi
		printf '%s/npm/node_modules/%s\n' "$agent_dir" "$name"
		;;
	git:*)
		body="${spec#git:}"
		ref="${body##*@}"
		# Only strip a trailing "@ref"; "git@host:org/repo" keeps its "@".
		case "$ref" in
		*/* | *:*) ;;
		*) [ "$ref" != "$body" ] && body="${body%@*}" ;;
		esac
		printf '%s/git/%s\n' "$agent_dir" "$body"
		;;
	*)
		printf '\n'
		;;
	esac
}
