// This will be the command line app that uses the tablature/instrument package api.
// It is a WIP and is not yet intended for use.
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/Guitarbum722/go-tabs/instrument"
	"github.com/Guitarbum722/go-tabs/tabio"
)

func main() {

	reader := bufio.NewReader(os.Stdin)

	fmt.Println("Which instrument?")
	fmt.Println("1 - Guitar")
	fmt.Println("2 - Bass Guitar")
	fmt.Println("3 - Ukulele")
	fmt.Println("4 - Seven String Guitar")
	fmt.Println("5 - Mandolin")
	fmt.Println("6 - Five String Bass Guitar")

	userChoice, err := reader.ReadString('\n')
	userChoice = strings.Replace(userChoice, "\n", "", -1)

	if err != nil {
		log.Fatalf("error with input %v", err)
	}

	var player instrument.Instrument

	switch userChoice {
	case "1":
		player = instrument.NewInstrument(instrument.InstGuitar)
	case "2":
		player = instrument.NewInstrument(instrument.InstBass)
	case "3":
		player = instrument.NewInstrument(instrument.InstUkulele)
	case "4":
		player = instrument.NewInstrument(instrument.InstGuitarSeven)
	case "5":
		player = instrument.NewInstrument(instrument.InstMandolin)
	case "6":
		player = instrument.NewInstrument(instrument.InstBassFive)
	default:
		log.Printf("Your choice of %v is not valid.\n", userChoice)
		os.Exit(1)
	}
	// player = instrument.NewInstrument(guitar)
	// player.Tune([]string{"C", "A♭", "D♭", "G♭", "B♭", "e♭"})

	fmt.Println("Enter the string, then fret number (ie e7 or g2)")
	fmt.Println("****************")
	fmt.Print(tabio.StringifyCurrentTab(player))

	f, err := os.OpenFile("guitar_tab.txt", os.O_RDWR|os.O_CREATE, 0755)
	if err != nil {
		log.Printf("error opening file %s", err)
	}
	w := tabio.NewTablatureWriter(f, 80)

	for z := 0; z < 1; {
		input, _ := reader.ReadString('\n')
		input = strings.Replace(input, "\n", "", -1)

		switch input {
		case "stage":
			tabio.StageTablature(player, w)
			for k := range player.Fretboard() {
				instrument.UpdateCurrentTab(player, k, "-")
			}
			fmt.Print(tabio.StringifyCurrentTab(player))
		case "export":
			if err := tabio.ExportTablature(player, w); err != nil {
				log.Fatalf("there was an error exporting the tablature::: %s\n", err)
			}
			for k := range player.Fretboard() {
				instrument.UpdateCurrentTab(player, k, "-")
			}
		case "quit":
			z++
		case "tune":
			fmt.Println("Please enter the desired tuning with each note separated by colons (:)")
			tuning, err := reader.ReadString('\n')
			if err != nil {
				log.Fatalf("there was an error tuning the instrument::: %s", err)
			}
			tuning = strings.TrimRight(tuning, "\n")
			player.Tune(strings.Split(tuning, ":"))

			fmt.Print(tabio.StringifyCurrentTab(player))
		default:
			guitarString, fret, err := instrument.ParseFingerBoard(input)
			if err != nil {
				log.Printf("invalid entry: %s", err)
			} else {
				instrument.UpdateCurrentTab(player, guitarString, fret)
			}
			fmt.Print(tabio.StringifyCurrentTab(player))
		}
	}
	if err := f.Close(); err != nil {
		log.Fatalf("error closing the file %s", err)
	}
	os.Exit(0)
}
