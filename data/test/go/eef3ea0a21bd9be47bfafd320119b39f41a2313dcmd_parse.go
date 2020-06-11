package river

import (
  ui "github.com/gizak/termui"
)

var (
  EnableEJSONParsing = false
)

func CommandHandler() {
  go ReadCommands()
}

func ReadCommands() {
  for {
    msg := <-Input
    if msg[0] == '/' {
      Display <- NewConsoleMsg(COMMAND, msg)
      DispatchCommand(msg[1:])
    } else {
      FilteredCommands <- msg
    }
  }
}

func DispatchCommand(command string) {
  if command == "json" || command == "ejson" {
    EnableEJSONParsing = !EnableEJSONParsing
    if EnableEJSONParsing {
      Display <- NewConsoleMsg(COMMAND, "EJSON parsing enabled")
    } else {
      Display <- NewConsoleMsg(COMMAND, "EJSON parsing disabled")
    }
  } else if command == "exit" || command == "quit" {
    ui.StopLoop()
  }
}
