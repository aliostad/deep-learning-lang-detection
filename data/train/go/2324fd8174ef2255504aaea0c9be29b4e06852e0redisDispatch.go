package jobworker

import (
	"encoding/json"

	"github.com/rohan1020/retry"
)

func DispatchResult(jResult *JobResult) (err error) {

	defer func() {
		if r := recover(); r != nil {
			err, _ = r.(error)
		}
	}()

	js, err := json.Marshal(jResult)

	if err != nil {
		panic(err)
	}

	binkey := jResult.BinaryKey
	jid := jResult.Jobid

	SetJobResult(binkey, jid, string(js))

	keyDone := "done"

	if jResult.Status != 0 {
		keyDone = "error"
	}

	MoveJidToDoneSet(binkey, jid, keyDone)

	if jResult.BinaryKeyNext != "" {
		EnqueueJob(jResult.BinaryKeyNext, jResult.ResultStr)
	}

	return nil
}

func MoveJidToDoneSet(binkey, jid, keydone string) (val string) {

	key_process := "job:" + binkey + ":" + "processing"
	key_done := "job:" + binkey + ":" + keydone

	err := retry.Do(func() (err error) {
		_, err = Redis_dispatch.Client.SMove(key_process, key_done, jid).Result()
		return

	}, func() {
		Redis_dispatch.InitClient()
	})

	if err != nil {
		panic(err)
	}

	return

}
func SetJobResult(binkey, jid, resultStr string) (val string) {

	key := "job:" + binkey + ":" + "results"

	err := retry.Do(func() (err error) {
		_, err = Redis_dispatch.Client.HSet(key, jid, resultStr).Result()
		return

	}, func() {
		Redis_dispatch.InitClient()
	})

	if err != nil {
		panic(err)
	}

	return

}

func FlushCompletedJobs(binkey string) {

	key_done := "job:" + binkey + ":" + "done"

	var keys []string

	err := retry.Do(func() (err error) {
		keys, err = Redis_dispatch.Client.SMembers(key_done).Result()
		return

	}, func() {
		Redis_dispatch.InitClient()
	})

	if err != nil {
		panic(err)
	}

	if len(keys) > 0 {

		DeleteHash(binkey, "args", keys)
		// DeleteHash(binkey, "results", keys)
		DeleteFromPending(binkey, keys)
	}
	return

}
func DeleteFromPending(binkey string, jkey []string) {

	key := "job:" + binkey + ":" + "pending"

	err := retry.Do(func() (err error) {
		_, err = Redis_dispatch.Client.SRem(key, jkey...).Result()
		return

	}, func() {
		Redis_dispatch.InitClient()
	})

	if err != nil {
		panic(err)
	}

	return

}
func DeleteHash(binkey, typeof string, jkey []string) {

	key := "job:" + binkey + ":" + typeof

	err := retry.Do(func() (err error) {
		_, err = Redis_dispatch.Client.HDel(key, jkey...).Result()
		return

	}, func() {
		Redis_dispatch.InitClient()
	})

	if err != nil {
		panic(err)
	}

	return

}
