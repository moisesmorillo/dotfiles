package workerpool

import (
	"runtime"
	"testing"
	"time"
)

func TestProcessReturnsOnProducerError(t *testing.T) {
	if err := Process([]int{1, -1}, 2); err == nil {
		t.Fatal("expected an error")
	}
}

func TestProcessDoesNotRetainWorkersOnProducerError(t *testing.T) {
	baseline := runtime.NumGoroutine()
	for range 4 {
		// The first job gives the scheduler an opportunity to start workers
		// before the producer hits the error path.
		if err := Process([]int{1, -1}, 8); err == nil {
			t.Fatal("expected an error")
		}
	}

	deadline := time.Now().Add(500 * time.Millisecond)
	for runtime.NumGoroutine() > baseline+4 && time.Now().Before(deadline) {
		runtime.Gosched()
		time.Sleep(5 * time.Millisecond)
	}
	if got := runtime.NumGoroutine(); got > baseline+4 {
		t.Fatalf("workers were retained after producer error: baseline=%d current=%d", baseline, got)
	}
}
