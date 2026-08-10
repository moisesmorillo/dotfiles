package workerpool

import (
	"errors"
	"sync"
)

func Process(values []int, workers int) error {
	jobs := make(chan int)
	var group sync.WaitGroup
	for range workers {
		group.Add(1)
		go func() {
			defer group.Done()
			for range jobs {
			}
		}()
	}
	for _, value := range values {
		if value < 0 {
			return errors.New("negative value")
		}
		jobs <- value
	}
	close(jobs)
	group.Wait()
	return nil
}
