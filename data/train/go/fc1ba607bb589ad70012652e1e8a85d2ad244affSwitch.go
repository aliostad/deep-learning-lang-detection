package main
import "fmt"

func main() {

	i :=3

	switch i {
		case 0 :
			fmt.Println(0)
		case 1 :
			fmt.Println(1)
		case 2 :
			fmt.Println(2)
		case 3 :
			fmt.Println(3)
		case 4 :
			fmt.Println(4)
	}

	s := "world"

	switch s {
	case "hello":
		fmt.Println("hello")
	case "world":
		fmt.Println("world")
	default:
		fmt.Println("일치하는게 없습니다")
	}

	s = "hello"
	i = 2

	switch i {
	case 1:
		fmt.Println(1)
	case 2:
		if s == "hello" {
			fmt.Println("hello 2")
			break
		}
		fmt.Println(2)
	}

	//fallthrough

	i = 3

	switch i {
	case 4:
		fmt.Println("4 이상")
		fallthrough
	case 3:
		fmt.Println("3 이상")
		fallthrough
	case 2:
		fmt.Println("2 이상")
		fallthrough
	case 1:
		fmt.Println("1 이상")
		fallthrough
	case 0:
		fmt.Println("0 이상")
		// 마지막엔 fallthrough 붙일수 없음
	}

	switch i {
	case 2, 4, 6:
		fmt.Println("짝수")
	case 1, 3, 5:
		fmt.Println("홀수")
	}

	// 조건식도 가능
	i = 7
	switch  {
	case i >= 5 && i <10:
		fmt.Println("5이상 10미만")
	case i>=0 && i < 5:
		fmt.Println("0이상 5미만")
	}
}
