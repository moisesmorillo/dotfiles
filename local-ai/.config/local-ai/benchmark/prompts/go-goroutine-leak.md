A Go worker pool starts N workers ranging over a jobs channel. The producer returns early on its first error without
closing jobs, while the caller waits on a WaitGroup. Diagnose the leak and propose an idiomatic cancellation-safe fix
using context and clear channel ownership. Include a test strategy using `go test -race`; do not claim execution.
