package main

import "github.com/Lealen/engi"

func CameraGetX() float32 {
	return engi.GetCamera().X()
}

func CameraGetY() float32 {
	return engi.GetCamera().Y()
}

func CameraGetZ() float32 {
	return engi.GetCamera().Z()
}

func CameraMoveBy(p engi.Point) {
	if p.X != 0 {
		CameraMoveX(p.X)
	}
	if p.Y != 0 {
		CameraMoveY(p.Y)
	}
}

func CameraMoveX(m float32) {
	engi.Mailbox.Dispatch(engi.CameraMessage{engi.XAxis, m, true})
}

func CameraMoveY(m float32) {
	engi.Mailbox.Dispatch(engi.CameraMessage{engi.YAxis, m, true})
}

func CameraMoveZ(m float32) {
	engi.Mailbox.Dispatch(engi.CameraMessage{engi.ZAxis, m, true})
}

func CameraSet(p engi.Point) {
	if p.X != 0 {
		CameraSetX(p.X)
	}
	if p.Y != 0 {
		CameraSetY(p.Y)
	}
}

func CameraSetX(m float32) {
	engi.Mailbox.Dispatch(engi.CameraMessage{engi.XAxis, m, false})
}

func CameraSetY(m float32) {
	engi.Mailbox.Dispatch(engi.CameraMessage{engi.YAxis, m, false})
}

func CameraSetZ(m float32) {
	engi.Mailbox.Dispatch(engi.CameraMessage{engi.ZAxis, m, false})
}
