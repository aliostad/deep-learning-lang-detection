package main

import (
	"fmt"
)

func main() {

	// you must declare your var, and pass the pointer into Scan() below
	var currentManagerA, currentManagerB, currentManagerC, currentEngineerA, currentEngineerB, currentEngineerC bool
	var array [6]bool
	var Good1st [6]bool
	var Good2nd [6]bool
	var Good3rd [6]bool
	var Good4th [6]bool

	fmt.Print("Manager A: ")
	fmt.Scan(&currentManagerA)
	array[0] = currentManagerA

	fmt.Print("Manager B: ")
	fmt.Scan(&currentManagerB)
	array[1] = currentManagerB

	fmt.Print("Manager C: ")
	fmt.Scan(&currentManagerC)
	array[2] = currentManagerC

	fmt.Print("Engineer A: ")
	fmt.Scan(&currentEngineerA)
	array[3] = currentEngineerA

	fmt.Print("Engineer B: ")
	fmt.Scan(&currentEngineerB)
	array[4] = currentEngineerB

	fmt.Print("Engineer C: ")
	fmt.Scan(&currentEngineerC)
	array[5] = currentEngineerC

	Good1st = [6]bool{true, false, false, true, false, false}

	if Good1st == array {
		fmt.Println("Good")
		fmt.Println("Next Moves")
		fmt.Print("Manager A: ")
		fmt.Scan(&currentManagerA)
		array[0] = currentManagerA

		fmt.Print("Manager B: ")
		fmt.Scan(&currentManagerB)
		array[1] = currentManagerB

		fmt.Print("Manager C: ")
		fmt.Scan(&currentManagerC)
		array[2] = currentManagerC

		fmt.Print("Engineer A: ")
		fmt.Scan(&currentEngineerA)
		array[3] = currentEngineerA

		fmt.Print("Engineer B: ")
		fmt.Scan(&currentEngineerB)
		array[4] = currentEngineerB

		fmt.Print("Engineer C: ")
		fmt.Scan(&currentEngineerC)
		array[5] = currentEngineerC

		Good2nd = [6]bool{false, false, false, true, false, false}
		if Good2nd == array {
			fmt.Println("Good")
			fmt.Println("Next Moves")
			fmt.Print("Manager A: ")
			fmt.Scan(&currentManagerA)
			array[0] = currentManagerA

			fmt.Print("Manager B: ")
			fmt.Scan(&currentManagerB)
			array[1] = currentManagerB

			fmt.Print("Manager C: ")
			fmt.Scan(&currentManagerC)
			array[2] = currentManagerC

			fmt.Print("Engineer A: ")
			fmt.Scan(&currentEngineerA)
			array[3] = currentEngineerA

			fmt.Print("Engineer B: ")
			fmt.Scan(&currentEngineerB)
			array[4] = currentEngineerB

			fmt.Print("Engineer C: ")
			fmt.Scan(&currentEngineerC)
			array[5] = currentEngineerC

			Good3rd = [6]bool{false, false, false, true, true, true}
			if Good3rd == array {
				fmt.Println("Good")
				fmt.Println("Next Moves")
				fmt.Print("Manager A: ")
				fmt.Scan(&currentManagerA)
				array[0] = currentManagerA

				fmt.Print("Manager B: ")
				fmt.Scan(&currentManagerB)
				array[1] = currentManagerB

				fmt.Print("Manager C: ")
				fmt.Scan(&currentManagerC)
				array[2] = currentManagerC

				fmt.Print("Engineer A: ")
				fmt.Scan(&currentEngineerA)
				array[3] = currentEngineerA

				fmt.Print("Engineer B: ")
				fmt.Scan(&currentEngineerB)
				array[4] = currentEngineerB

				fmt.Print("Engineer C: ")
				fmt.Scan(&currentEngineerC)
				array[5] = currentEngineerC
				Good4th = [6]bool{false, false, false, false, true, true}
				if Good4th == array {
					fmt.Println("Good")
					fmt.Println("Next Moves")
					fmt.Print("Manager A: ")
					fmt.Scan(&currentManagerA)
					array[0] = currentManagerA

					fmt.Print("Manager B: ")
					fmt.Scan(&currentManagerB)
					array[1] = currentManagerB

					fmt.Print("Manager C: ")
					fmt.Scan(&currentManagerC)
					array[2] = currentManagerC

					fmt.Print("Engineer A: ")
					fmt.Scan(&currentEngineerA)
					array[3] = currentEngineerA

					fmt.Print("Engineer B: ")
					fmt.Scan(&currentEngineerB)
					array[4] = currentEngineerB

					fmt.Print("Engineer C: ")
					fmt.Scan(&currentEngineerC)
					array[5] = currentEngineerC

				} else {
					fmt.Println("Bad!")
				}
			} else {
				fmt.Println("Bad!")
			}

		} else {
			fmt.Println("Bad!")

		}

	} else {
		fmt.Println("Bad")
	}

	fmt.Println(array)

}
