package main

import (
	"../../ozsndqueue"
	"fmt"
	"time"
)

func main() {
	soundManager := ozsndqueue.CreateSoundManager(5)

	soundManager.Put("PATH_TO_FILE1", 0)
	soundManager.Put("PATH_TO_FILE1_1", 0)
	soundManager.Put("PATH_TO_FILE2", 1)
	soundManager.Put("PATH_TO_FILE3", 2)
	soundManager.Put("PATH_TO_FILE4", -1)

	fmt.Println(soundManager)


	soundManager = ozsndqueue.CreateSoundManager(1)
	soundManager.Put("PATH_TO_FILE1", 0)
	fmt.Println(soundManager)
	soundManager.PlayNext()
	fmt.Println(soundManager)

	soundManager = ozsndqueue.CreateSoundManager(5)
	soundManager.Put("PATH_TO_FILE1", 0)
	soundManager.Put("PATH_TO_FILE2", 0)
	soundManager.Put("PATH_TO_FILE3", 1)
	soundManager.Put("PATH_TO_FILE4", 2)
	soundManager.Put("PATH_TO_FILE5", 2)
	fmt.Println(soundManager)
	soundManager.PlayNext()
	fmt.Println(soundManager)
	soundManager.PlayNext()
	fmt.Println(soundManager)
	soundManager.PlayNext()
	fmt.Println(soundManager)
	soundManager.PlayNext()
	fmt.Println(soundManager)
	soundManager.PlayNext()
	fmt.Println(soundManager)


	soundManager = ozsndqueue.CreateSoundManager(10)
	go soundManager.StartMainLoop()

	soundManager.Put("_test/data/wavtest.wav", 0)
	soundManager.Put("_test/data/mp3test.mp3", 0)
	soundManager.Put("_test/data/wavtest.wav", 1)
	soundManager.Put("_test/data/mp3test.mp3", 2)
	soundManager.Put("_test/data/wavtest.wav", 2)

	// まだ再生終了のコールバックがないので、
	// タイマーを使ってメインループを終了させる。
	time.Sleep(7500000000)
	soundManager.Stop()
	fmt.Println("stop play.")
}
