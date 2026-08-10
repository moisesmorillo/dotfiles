import { useCallback, useState } from "react";
import { useQuery } from "@tanstack/react-query";

export function ClusterPanel() {
  const [selectedCluster, setSelectedCluster] = useState("dev");
  const query = useQuery({
    queryKey: ["cluster", selectedCluster],
    queryFn: () => fetch(`/api/clusters/${selectedCluster}`).then((response) => response.json()),
  });
  const refresh = useCallback(() => query.refetch({ cluster: selectedCluster }), []);

  return (
    <button onClick={refresh} data-cluster={selectedCluster}>
      Refresh
    </button>
  );
}
