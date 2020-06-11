package display

import (
	"log"
	"time"

	"../i2c"
)

func New() *i2c.I2C {

	device, err := i2c.NewI2C(0x70, 1)
	if err != nil {
		log.Fatal(err)
	}

	device.Write([]byte{0x21, 0x00})
	device.Write([]byte{0x81, 0x00})

	return device

}

func Success() {
	device := New()

	Clear(device)

	device.Write([]byte{0x00, 0x18})
	device.Write([]byte{0x02, 0x18})
	device.Write([]byte{0x04, 0x18})
	device.Write([]byte{0x06, 0x99})
	device.Write([]byte{0x08, 0xDB})
	device.Write([]byte{0x0a, 0x7E})
	device.Write([]byte{0x0c, 0x3C})
	device.Write([]byte{0x0e, 0x18})
	time.Sleep(2 * time.Second)
	Clear(device)
	device.Close()
}

func Error() {
	device := New()

	Clear(device)

	device.Write([]byte{0x01, 0xC3})
	device.Write([]byte{0x03, 0x66})
	device.Write([]byte{0x05, 0x3C})
	device.Write([]byte{0x07, 0x18})
	device.Write([]byte{0x09, 0x18})
	device.Write([]byte{0x0b, 0x3C})
	device.Write([]byte{0x0d, 0x66})
	device.Write([]byte{0x0f, 0xC3})
	time.Sleep(2 * time.Second)
	Clear(device)
	device.Close()

}

func Clear(device *i2c.I2C) {
	for i := 0; i <= 0x0f; i++ {
		device.Write([]byte{byte(i), 0x00})
	}
}
