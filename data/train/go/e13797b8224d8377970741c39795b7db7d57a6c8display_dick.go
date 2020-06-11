package main

import (
	"log"
	"time"

	"../i2c"
)

func main() {
	i2c, err := i2c.NewI2C(0x70, 1)
	if err != nil {
		log.Fatal(err)
	}
	defer i2c.Close()

	i2c.Write([]byte{0x21, 0x00})
	i2c.Write([]byte{0x81, 0x00})

	for {

		for i := 0; i <= 0x0f; i++ {
			i2c.Write([]byte{byte(i), 0x00})
		}
		i2c.Write([]byte{0x00, 0x66})
		i2c.Write([]byte{0x02, 0x99})
		i2c.Write([]byte{0x04, 0x66})
		i2c.Write([]byte{0x06, 0x24})
		i2c.Write([]byte{0x08, 0x24})
		i2c.Write([]byte{0x0a, 0x18})
		time.Sleep(time.Millisecond * 500)

		for i := 0; i <= 0x0f; i++ {
			i2c.Write([]byte{byte(i), 0x00})
		}

		i2c.Write([]byte{0x00, 0x66})
		i2c.Write([]byte{0x02, 0x99})
		i2c.Write([]byte{0x04, 0x66})
		i2c.Write([]byte{0x06, 0x24})
		i2c.Write([]byte{0x08, 0x24})
		i2c.Write([]byte{0x0a, 0x24})
		i2c.Write([]byte{0x0c, 0x18})

		i2c.Write([]byte{0x01, 0x66})
		i2c.Write([]byte{0x03, 0x99})
		i2c.Write([]byte{0x05, 0x66})
		i2c.Write([]byte{0x07, 0x24})
		i2c.Write([]byte{0x09, 0x24})
		i2c.Write([]byte{0x0b, 0x24})
		i2c.Write([]byte{0x0d, 0x18})
		time.Sleep(time.Millisecond * 500)

		for i := 0; i <= 0x0f; i++ {
			i2c.Write([]byte{byte(i), 0x00})
		}
		i2c.Write([]byte{0x01, 0x66})
		i2c.Write([]byte{0x03, 0x99})
		i2c.Write([]byte{0x05, 0x66})
		i2c.Write([]byte{0x07, 0x24})
		i2c.Write([]byte{0x09, 0x24})
		i2c.Write([]byte{0x0b, 0x24})
		i2c.Write([]byte{0x0d, 0x24})
		i2c.Write([]byte{0x0f, 0x18})
		time.Sleep(time.Millisecond * 500)
	}

}
