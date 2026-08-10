package workerpool

import "testing"

func TestProcessReturnsOnProducerError(t *testing.T) {
	if err := Process([]int{1, -1}, 2); err == nil {
		t.Fatal("expected an error")
	}
}
