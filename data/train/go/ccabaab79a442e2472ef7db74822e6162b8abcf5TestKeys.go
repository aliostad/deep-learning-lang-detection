package testKeys

import (
	"github.com/ITR13/campusFighterI/inputManager"
	"github.com/veandco/go-sdl2/sdl"
)

func StartTestKeys(window *sdl.Window, controlManager *inputManager.ControlManager, updateToExitTo inputManager.Update) inputManager.Update {
	parsedInput := ParsedInput{false, false, false, false, false, false, false, false, false, false, false, false}
	subRunning := true
	return func(state int) int {
		if state == 0 {
			inputManager.UpdateFunctions = append(inputManager.UpdateFunctions, Draw(window, &parsedInput, &subRunning))
		}
		if controlManager.Running {
			currentInput := ParsedInput{controlManager.Player1.UpF || controlManager.Player1.Up, controlManager.Player1.DownF || controlManager.Player1.Down, controlManager.Player1.LeftF || controlManager.Player1.Left, controlManager.Player1.RightF || controlManager.Player1.Right, controlManager.Player1.AF || controlManager.Player1.A, controlManager.Player1.BF || controlManager.Player1.B, controlManager.Player2.UpF || controlManager.Player2.Up, controlManager.Player2.DownF || controlManager.Player2.Down, controlManager.Player2.LeftF || controlManager.Player2.Left, controlManager.Player2.RightF || controlManager.Player2.Right, controlManager.Player2.AF || controlManager.Player2.A, controlManager.Player2.BF || controlManager.Player2.B}
			if (parsedInput[5] && !currentInput[5]) || (parsedInput[11] && !currentInput[11]) {
				if parsedInput[13] {
					subRunning = false
					if updateToExitTo == nil {
						inputManager.Running = false
					} else {
						inputManager.UpdateFunctions = append(inputManager.UpdateFunctions, updateToExitTo)
					}
					return -1
				} else if parsedInput[12] {
					parsedInput[13] = true
				} else {
					parsedInput[12] = true
				}
			}
			for i := 0; i < 12; i++ {
				parsedInput[i] = (currentInput[i])
				if parsedInput[i] && i != 5 && i != 11 {
					parsedInput[12] = false
					parsedInput[13] = false
				}
			}
		} else {
			subRunning = false
			if updateToExitTo == nil {
				inputManager.Running = false
			} else {
				inputManager.UpdateFunctions = append(inputManager.UpdateFunctions, updateToExitTo)
			}
			return -1
		}
		return 1
	}
}
