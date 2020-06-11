// Visitor and Double Dispatch
/*
Even though the Visitor pattern is built on the double dispatch principle,
that's not its primary purpose.
Visitor allows adding "external" operations to a whole class hierarchy without changing existing code of these classes.

visitor 使用 double dispatch 来实现
在所有的具体类里去 accept 一个 visitor 参数，然后通过 v 调用对自己操作的函数
这样就可以把对本类的所有操作放在类之外

而图/数组/树的遍历也可以将这些具体类看作统一的对象，比如本代码中，就是 component 来看待
因为这些对象都实现了 accept 接口
*/
// visitor introduction
// https://refactoring.guru/design-patterns/visitor

// double dispatch
// https://refactoring.guru/design-patterns/visitor-double-dispatch

package main

func main() {
	var myVisitor = new(visitor)
	var array = []component{&text{101, "cn"}, &pic{640, 480}}

	// traversal print
	for i := 0; i < len(array); i++ {
		array[i].accept(myVisitor)
	}
}
