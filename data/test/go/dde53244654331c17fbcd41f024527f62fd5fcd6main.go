/**
 * Created with IntelliJ IDEA.
 * Title: ${NAME}
 * Description:
 * User: xieguoqiang
 * @since: 13-8-18 下午10:09
 * @version 1.0
 */
package main

import (
	"com/acorn"
	"fmt"
)

func main() {
	acorn.Hello()
	acorn.PrintMath()
	acorn.InitVar()
	fmt.Println(acorn.E) //调用其他包的常量
	acorn.ArrayProcess()
	acorn.IfProcess(1)
	acorn.IfProcess(2)
	acorn.IfProcess(4)

	acorn.SwithProcess(1)
	acorn.SwithProcess(2)
	acorn.SwithProcess(3)
	acorn.SwithProcess(5)
	acorn.SwithProcess(6)
	acorn.SwithProcess(2342)
}
