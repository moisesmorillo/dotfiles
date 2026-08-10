A React component uses TanStack Query and stores `selectedCluster` in state. A callback created with
`useCallback([])` calls `refetch({ cluster: selectedCluster })`, so it always uses the initial cluster. Provide the
smallest type-safe fix, explain whether `refetch` accepts arbitrary variables for a query, and propose a Vitest test
that catches the bug.
