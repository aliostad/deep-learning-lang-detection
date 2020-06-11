package main

func main() {
	manager := &Manager{}
	//prototypeの作成
	outputText := NewOutputText("-")
	outputText2 := NewOutputText("+")
	manager.register("gakubox", outputText)
	manager.register("gakubox2", outputText2)

	doubleText := NewDoubleText("(((((((((((っ･ω･)っ ﾌﾞｰﾝ")
	manager.register("gakubox3", doubleText)

	//prototypeから実態を生成する
	p1 := manager.create("gakubox")
	p1.use("gaku")
	p2 := manager.create("gakubox2")
	p2.use("gakugaku")
	p3 := manager.create("gakubox")
	p3.use("gakugakugaku")

	p4 := manager.create("gakubox3")
	p4.use("test")

	/*
		出力結果
		-gaku-
		+gakugaku+
		-gakugakugaku-
		(((((((((((っ･ω･)っ ﾌﾞｰﾝtest(((((((((((っ･ω･)っ ﾌﾞｰﾝ
		(((((((((((っ･ω･)っ ﾌﾞｰﾝtest(((((((((((っ･ω･)っ ﾌﾞｰﾝ
	*/

}
