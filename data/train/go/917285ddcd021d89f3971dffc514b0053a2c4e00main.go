package main

import (
  "bufio"
  "fmt"
  "os"
  "bytes"
  "strings"
  "strconv"
  "io/ioutil"
)

func ask(question string) string {
  consolereader := bufio.NewReader(os.Stdin)
  fmt.Print(question + " : ")
  answer, err := consolereader.ReadString('\n')

  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }

  return answer
}

func write(service string,description string,command string,param string){

  service = strings.TrimSpace(service)
  description = strings.TrimSpace(description)

  command = strings.TrimSpace(command)
  command = strconv.Quote(command)
  param = strings.TrimSpace(param)
  param = strconv.Quote(param)

  var buffer bytes.Buffer
  buffer.WriteString("#! /bin/sh\n")

  buffer.WriteString("NAME=\""+service+"\"\n")
  buffer.WriteString("DESC=\""+description+"\"\n")
  buffer.WriteString("PIDFILE=\"/var/run/${NAME}.pid\"\n")
  buffer.WriteString("LOGFILE=\"/var/log/${NAME}.log\"\n")

  buffer.WriteString("COMMAND="+command+"\n")
  buffer.WriteString("COMMAND_OPT="+param+"\n")

  buffer.WriteString("START_OPTS=\"--start --background --make-pidfile --pidfile ${PIDFILE} --name $NAME --exec $COMMAND -- $COMMAND_OPT\"\n")
  buffer.WriteString("STOP_OPTS=\"--stop --pidfile ${PIDFILE}\"\n")

  buffer.WriteString("case \"$1\" in\n")

  buffer.WriteString("start)\n")
    buffer.WriteString("    start-stop-daemon $START_OPTS >> $LOGFILE\n")
    buffer.WriteString("    echo \"start $NAME completed\"\n")
  buffer.WriteString(";;\n")

  buffer.WriteString("stop)\n")
    buffer.WriteString("    start-stop-daemon $STOP_OPTS\n")
    buffer.WriteString("    rm -f $PIDFILE\n")
    buffer.WriteString("    echo \"stop $NAME completed\"\n")
  buffer.WriteString(";;\n")

  buffer.WriteString("restart)\n")
    buffer.WriteString("    start-stop-daemon $STOP_OPTS\n")
    buffer.WriteString("    sleep 1\n")
    buffer.WriteString("    start-stop-daemon $START_OPTS >> $LOGFILE\n")
    buffer.WriteString("    echo \"restart $NAME completed\"\n")
  buffer.WriteString(";;\n")

  buffer.WriteString("*)\n")
    buffer.WriteString("    N=/etc/init.d/$NAME\n")
    buffer.WriteString("    echo \"Usage: $N {start|stop|restart}\" >&2\n")
    buffer.WriteString("    exit 1\n")
    buffer.WriteString("    ;;\n")
  buffer.WriteString("esac\n")
  buffer.WriteString("exit 0")

  err := ioutil.WriteFile(service, buffer.Bytes(), 0755)
  if err != nil {
      panic(err)
  }
}

func main() {
  service := ask("Enter your service name")
  description := ask("Enter your service description")
  command := ask("Enter full path of application")
  param := ask("Enter your application parameter")
  write(service,description,command,param)
}
