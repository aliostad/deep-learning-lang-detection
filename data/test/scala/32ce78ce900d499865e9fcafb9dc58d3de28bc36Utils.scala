package pl.dykg.stream.password


object Utils {


  implicit class StringUtils(original: String) {

    def switchCaseAt(charIndex: Int): String = {
      val oldCharacter = original.charAt(charIndex)
      val newCharacter = if (oldCharacter.isUpper) oldCharacter.toLower else oldCharacter.toUpper
      original.replaceCharAt(charIndex, newCharacter)
    }

    def replaceCharAt(charIndex: Int, character: Char): String = {
      original.substring(0, charIndex) + character + original.substring(charIndex + 1)
    }
  }

}
