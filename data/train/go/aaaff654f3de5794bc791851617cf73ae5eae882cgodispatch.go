package cgodispatch

/*
#include <stdio.h>
#include <stdlib.h>

#include <dispatch/dispatch.h>

extern void Goexecve();

static inline int c_async(char* s) {
	dispatch_queue_t gQueue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);

	dispatch_async(gQueue, ^{

		dispatch_queue_t sQueue = dispatch_queue_create(
			"com.github.zchee.cgoexample", DISPATCH_QUEUE_CONCURRENT);

			for (int i = 0; i < 10; i++) {
				dispatch_sync(sQueue, ^{
					// printf("block %d\n", i);
					Goexecve(s);
				});
			}

			dispatch_release(sQueue);

			printf("finish\n");
			exit(0);
		});

	dispatch_main();

	return 0;
}
*/
import "C"
import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
)

// Wrapper exec.Command
//
// Output stdout and stderr for os.Stdout
func Exec(argc string, argv ...string) (stdout []byte, stderr error) {
	cmd := exec.Command(argc, argv...)
	read, write, _ := os.Pipe()

	defer func() {
		read.Close()
	}()

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stdout

	stderr = cmd.Run()
	write.Close()

	readOut, readErr := ioutil.ReadAll(read)
	if readErr != nil {
		return readOut, readErr
	}
	return
}

// Support space separate cmd args for exec.Command()
func Spawn(cmd string) (stdout string, stderr error) {
	var o []byte

	split := strings.Split(cmd, " ")
	argc := split[0]

	var argv = strings.Fields(split[1])
	for i := 2; i < len(split); i++ {
		argv = append(argv, split[i])
		fmt.Println(argv)
	}

	o, err := Exec(argc, argv...)

	return string(o), err
}

// Export execute binary use os.exec func to C-land
//export Goexecve
func Goexecve(char *C.char) {
	out, _ := Spawn(C.GoString(char))
	fmt.Printf("%s\n", out)
}

// Endpoint of outside go pkg
//
// callgraph:
//   Async() -> C.c_async -> Goexecve() with dispath -> Spawn() -> Exec()
func Async(args string) {
	C.c_async(C.CString(args))
}
