package	FactsHandler

import	scala.collection.mutable.Map

object	Manage
{
	def		initAlphabet(initFacts: String): Map[Char, Boolean] = {
		var	map				= Map[Char, Boolean]()

		val	alphabet		= ('A' to 'Z')
		val	initStr			= initFacts.replace("=", "")

		for (c <- alphabet)
			map += (c -> false)
		for (c <- initStr)
			map(c) = true

		return (map)
	}

	def		showQuery(instStr: String, map: Map[Char, Boolean])
	{
		println( "\u001b[96m"+instStr+"\u001b[0m:" )

		val	instructions	= instStr.replace("?", "")

		for (c <- instructions) {
			val (char, value) = (c, map(c))

						print(s"$char -> ")
			if (value)	print("\u001b[92m")
			else		print("\u001b[91m")
						println(s"${value}\u001b[0m")
		}
	}
}
