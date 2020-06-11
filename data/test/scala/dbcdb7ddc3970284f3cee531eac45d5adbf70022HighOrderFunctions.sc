import traits.collections.user.User

object HighOrderFunctions {

	val users = Array.fill(10)(User.generate) //> users  : Array[traits.collections.user.User] = Array(恉埔㽂ⷬ渞ᇝ嵙�
                                                  //| �譔达, 눅쟐氣ኊ诅ၰ㍟㓟팟◰, secret: 㤳힖꘽駿岥棩쉮㷒↭
                                                  //| 앥, 坮렀큒禰ଚ箓俁ꣂ灞蟊, 插蚏꺯튫쉃輰铥䗊当談, secret:
                                                  //|  䪱఍鈻럏Żᅫ䋩鼡粌헳, 譳ꃤ≆⪈앾밖霁썰忢魂, ၤݖ豾텚�
                                                  //| ��ጆ韏얆䳡鶃, secret: 㯣ꫜ탂䚁鲭渢碆짓痤へ, 䭑뫻謘䘲穞�
                                                  //| �龁慠ԃ豼, 芵楎곉辵і뀱푉쾳垂嶥, secret: 塰褍ᛤḐ상扠겋�
                                                  //| �⍂礋, ቧ僝ᙺẐ赻㭐㴱ꠒᴷ糖, 훸刺퓕珄ᱰ䱇蠺⟒횵쎀, sec
                                                  //| ret: ⅄䣒ꋓዕꇜ汔㻠췅김뉭, 䴕끁ꖸ彘䜷㯦Ů얟뼄욺, 㙻궟�
                                                  //| �则蟋梧러퀖≛䧢, secret: ᶦ갾垊훪좾⵾阨蛣馅➨, ଍풖斾쓷
                                                  //| ꥐ腤ⴴ㥂盝ꔋ, 掕昻䐧Ѧ癢魄뵵⛙Я‖, secret: 饢큻⯁爺燿륞
                                                  //| 髗쫬졧搷, 멤ྤ匣ཕᵋᭃ旵蟗깴㴥, 括瑿Ҟ⮈듌㚂䊹ڳ뀠뛍, 
                                                  //| secret: 牬칡츔窳喀˃䈌뛎蠪쫒, 蠣ബ놌Ნ깃ꗋ칚膯鸩ᨲ, ․�
                                                  //| �轥떹愼 儌掰髢ᚵ, secret: 洧븾朴릆ὤ蔝ꦧせ沭ウ, 솁損딷�
                                                  //| �ට茦爵坽ᔷ谎, 愷็⽗폻ᾩ广秥섲깫쩿, secret: 㨮ыy㬪꼩硇
                                                  //| 羪ᆋ怍侰)

	users.filter { _.age > 18 }.map { user => s"${user.name} [${user.username}], ${user.age} old " }
                                                  //> res0: Array[String] = Array("恉埔㽂ⷬ渞ᇝ嵙ꥡ譔达 [눅쟐氣ኊ诅
                                                  //| ၰ㍟㓟팟◰], 26 old ", "坮렀큒禰ଚ箓俁ꣂ灞蟊 [插蚏꺯튫쉃
                                                  //| 輰铥䗊当談], 78 old ", "譳ꃤ≆⪈앾밖霁썰忢魂 [ၤݖ豾텚镧�
                                                  //| ��韏얆䳡鶃], 76 old ", "䭑뫻謘䘲穞绋龁慠ԃ豼 [芵楎곉辵і뀱
                                                  //| 푉쾳垂嶥], 26 old ", "䴕끁ꖸ彘䜷㯦Ů얟뼄욺 [㙻궟氤则蟋梧�
                                                  //| ��퀖≛䧢], 52 old ", "଍풖斾쓷ꥐ腤ⴴ㥂盝ꔋ [掕昻䐧Ѧ癢魄�
                                                  //| �⛙Я‖], 60 old ", "멤ྤ匣ཕᵋᭃ旵蟗깴㴥 [括瑿Ҟ⮈듌㚂䊹�
                                                  //| �뀠뛍], 56 old ", "솁損딷쒌ට茦爵坽ᔷ谎 [愷็⽗폻ᾩ广秥�
                                                  //| �깫쩿], 30 old ")


	val a = Array(1,2,3,4,5)                  //> a  : Array[Int] = Array(1, 2, 3, 4, 5)
	val b = List(5,2,8,1,3)                   //> b  : List[Int] = List(5, 2, 8, 1, 3)
	
	//Generate a Array of List
	a.map(i => b.take(i))                     //> res1: Array[List[Int]] = Array(List(5), List(5, 2), List(5, 2, 8), List(5, 2
                                                  //| , 8, 1), List(5, 2, 8, 1, 3))
	//Map and transform the lists in elements
	a.map(i => b.take(i)).flatten             //> res2: Array[Int] = Array(5, 5, 2, 5, 2, 8, 5, 2, 8, 1, 5, 2, 8, 1, 3)
	a.flatMap(i => b.take(i))                 //> res3: Array[Int] = Array(5, 5, 2, 5, 2, 8, 5, 2, 8, 1, 5, 2, 8, 1, 3)

	//The same thing!
	a.reduceLeft((a,b) => a+b)                //> res4: Int = 15
	a.reduceLeft(_+_)                         //> res5: Int = 15

	a.foldLeft("00")(_+_)                     //> res6: String = 0012345


	b.find(_%3 == 0).map( _/3).getOrElse(0)   //> res7: Int = 1


	def completeFunction(i:Int): Int = ???    //> completeFunction: (i: Int)Int

	val partialFunction:PartialFunction[Any,String] = {
		case i:Int => "Number"
		case s:String => "The string "+s
	}                                         //> partialFunction  : PartialFunction[Any,String] = <function1>

	partialFunction(1)                        //> res8: String = Number

	partialFunction("MyName")                 //> res9: String = The string MyName

	def scalaWhile(condition: => Boolean)(func: => Unit): Unit = {
		if (condition) {
			func
			scalaWhile(condition)(func)
		}
	}                                         //> scalaWhile: (condition: => Boolean)(func: => Unit)Unit

	var i = 0                                 //> i  : Int = 0
	scalaWhile(i<5){
		println(i)
		i += 1
	}                                         //> 0
                                                  //| 1
                                                  //| 2
                                                  //| 3
                                                  //| 4
}