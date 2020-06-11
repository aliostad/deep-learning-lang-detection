package org.lipicalabs.lipica.core.vm

/**
 *
 * @since 2015/10/25
 * @author YANAGISAWA, Kentaro
 */
object ManaCost {

	val Balance = 20
	val SHA3 = 30
	val SHA3Word  = 6
	val SLoad = 50
	val Stop = 0
	val Return = 0
	val ClearSStore = 5000
	val SetSStore = 20000
	val ResetSStore = 5000
	val RefundSStore = 15000
	val Create = 32000

	val SuicideRefund = 24000

	val StipendCall = 2300
	val Call = 40
	val ValueTransferCall = 9000
	val NewAccountCall = 25000

	val Memory = 3

	val LogMana = 375
	val LogDataMana = 8
	val LogTopicMana = 375

	val CopyMana = 3

	val ExpMana = 10
	val ExpByteMana = 10

	/** ゼロでないデータ１バイトにかかるフィー。 */
	val TX_NO_ZERO_DATA = 68
	/** ゼロであるデータ１バイトにかかるフィー。 */
	val TX_ZERO_DATA = 4
	/** １トランザクションにかかるフィー。 */
	val TRANSACTION = 21000

	val CreateData = 200

	//以下のメモリ消費容量計算において、２次の項を割るための除数。
	private val QuadraticCoefficientDivisor = 512L

	/**
	 * メモリ消費の増分に対する平方（２乗）課金を計算します。
	 */
	def calculateQuadraticMemoryMana(newMemoryUsage: Long, oldMemoryUsage: Long): Long = {
		val memWordsNew = VMWord.countWords(newMemoryUsage)
		val newFee = calculateQuadraticMana(memWordsNew)

		val memWordsOld = VMWord.countWords(oldMemoryUsage)
		val oldFee = calculateQuadraticMana(memWordsOld)

		newFee - oldFee
	}

	private def calculateQuadraticMana(numberOfWords: Long): Long = {
		//消費ワード数に対して線形の項。
		val linearElement = ManaCost.Memory * numberOfWords
		//消費ワード数に対して２次の項。
		val quadraticElement = (numberOfWords * numberOfWords) / QuadraticCoefficientDivisor
		linearElement + quadraticElement
	}
}
