package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"

	"github.com/speedland/go/tools/gaeutil"
	"github.com/speedland/go/x/xerrors"
)

var (
	appName       = flag.String("application", "localapp", "gae application name")
	deploymentDir = flag.String("deployment", "./deployment", "deployment directory")
)

func main() {
	log.SetPrefix("[gendispatch] ")
	log.SetFlags(0)
	flag.Parse()
	if len(*appName) == 0 {
		flag.Usage()
		os.Exit(2)
	}
	modules, err := gaeutil.CollectModules(*deploymentDir)
	xerrors.MustNil(err)

	dir, err := ioutil.TempDir("", "genyamltmp")
	xerrors.MustNil(err)
	defer os.RemoveAll(dir)
	var dispatchFilePath = filepath.Join(dir, "dispatch.yaml")
	genDispatch(dispatchFilePath, *appName, modules)

	var args []string
	args = append(args, fmt.Sprintf("--application=%s", *appName))
	args = append(args, "--storage_path", ".localdata")
	args = append(args, "--datastore_consistency_policy", "consistent")
	args = append(args, dispatchFilePath)
	args = append(args, filepath.Join(*deploymentDir, "default/app.yaml"))
	for _, m := range modules {
		args = append(args, filepath.Join(*deploymentDir, fmt.Sprintf("%s/app.yaml", m)))
	}

	cmd := exec.Command("dev_appserver.py", args...)
	log.Println(strings.Join(append([]string{"$ dev_appserver.py"}, args...), " "))
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Start(); err != nil {
		log.Fatal(err)
	}
	log.Println("Starting dev_appserver with", cmd.Process.Pid)
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	s := <-c
	log.Println("Killing", cmd.Process.Pid, "with", s)
	cmd.Process.Signal(s)
	cmd.Process.Wait()
}

func genDispatch(path string, appName string, modules []string) {
	dispatchFile, err := os.Create(path)
	xerrors.MustNil(err)
	defer dispatchFile.Close()
	fmt.Fprintf(dispatchFile, "application: %s\n", appName)
	fmt.Fprintf(dispatchFile, "\n")
	fmt.Fprintf(dispatchFile, "dispatch:\n")
	for _, m := range modules {
		fmt.Fprintf(dispatchFile, "- url: \"*/%s/*\"\n", strings.Replace(m, "-", "/", -1))
		fmt.Fprintf(dispatchFile, "  module: %s\n", m)
	}
	fmt.Fprintf(dispatchFile, "- url: \"*/*\"\n")
	fmt.Fprintf(dispatchFile, "  module: default\n")
}
