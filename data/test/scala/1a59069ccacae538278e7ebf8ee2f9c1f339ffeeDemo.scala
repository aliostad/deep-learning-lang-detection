package lt.astrauskas.oop2

object Demo {

  def show(pointerType: String, name: String, value: String): Unit = {
    println("(%s) %10s: %s".format(pointerType, name, value))
  }

  def show(pointerType: String, name: String, value: Int): Unit = {
    show(pointerType, name, value.toString())
  }

  def show(pointerType: String, name: String, value: Double): Unit = {
    show(pointerType, name, value.toString())
  }

  def show(pointerType: String, human: IHuman): Unit = {
    show(pointerType, "First name", human.firstName())
    show(pointerType, "Last name", human.lastName())
    show(pointerType, "Full name", human.fullName())
    show(pointerType, "REPR", human.toString())
  }

  def show(pointerType: String, student: IStudent): Unit = {
    show(pointerType, student.asInstanceOf[IHuman])
    show(pointerType, "Class", student.schoolClass())
  }

  def show(pointerType: String, teacher: ITeacher): Unit = {
    show(pointerType, teacher.asInstanceOf[IHuman])
    show(pointerType, "Degree", teacher.degree())
    show(pointerType, "Subject", teacher.subject())
  }

  def show(pointerType: String, player: IPlayer): Unit = {
    show(pointerType, "Points", player.points())
    show(pointerType, "Status", player.status())
    show(pointerType, "REPR", player.toString())
  }

  def show(pointerType: String, chessPlayer: IChessPlayer): Unit = {
    show(pointerType, chessPlayer.asInstanceOf[IPlayer])
    show(pointerType, "Win", chessPlayer.win())
    show(pointerType, "Loose", chessPlayer.loose())
    show(pointerType, "Draw", chessPlayer.draw())
    show(pointerType, "Played", chessPlayer.played())
  }

  def show(pointerType: String, quakePlayer: IQuakePlayer): Unit = {
    show(pointerType, quakePlayer.asInstanceOf[IPlayer])
    show(pointerType, "Deaths", quakePlayer.deaths())
    show(pointerType, "Kills", quakePlayer.kills())
    show(pointerType, "Rounds", quakePlayer.roundsPlayed())
  }

  def main(args: Array[String]): Unit = {
    println("Start.")

    println("----------Testing human---------")
    var human1: IHumanUse = new Human("Vytautas", "Astrauskas")
    show("H", human1)

    println("----------Testing student---------")
    var student: IStudentUse = new Student(human1, 10)
    show("H", human1)
    show("S", student)

    println("----------Testing teacher---------")
    var human2: IHumanUse = new Human("Petras", "Petraitis")
    var teacher: ITeacherUse = new Teacher(
        human2, "m.m.", "matematika")
    show("H", human2)
    show("T", teacher)

    println("----------Testing player---------")
    var player1: IPlayerUse = new Player()
    show("P", player1)

    println("----------Testing chess player---------")
    var chessPlayer: IChessPlayerUse = new ChessPlayer(
        player1, 3, 8, 2)
    show("P", player1)
    show("C", chessPlayer)

    println("----------Testing Quake player---------")
    var player2: IPlayerUse = new Player()
    var quakePlayer: IQuakePlayerUse = new QuakePlayer(
        player2, 30, 13, 8)
    show("P", player2)
    show("Q", quakePlayer)

    println("----------Testing chess student---------")
    var studentPlayingChess = new StudentPlayingChess(
        student, chessPlayer)
    show("H", human1)
    show("S", student)
    show("P", player1)
    show("C", chessPlayer)
    show("SC", studentPlayingChess.asInstanceOf[IHuman])
    show("SC", studentPlayingChess.asInstanceOf[IStudent])
    show("SC", studentPlayingChess.asInstanceOf[IPlayer])
    show("SC", studentPlayingChess.asInstanceOf[IChessPlayer])

    println("----------Testing chess teacher---------")
    var player3: IPlayerUse = new Player()
    var chessPlayer2: IChessPlayerUse = new ChessPlayer(
        player3, 1, 1, 1)
    var teacherPlayingChess = new TeacherPlayingChess(
        teacher, chessPlayer2)
    show("H", human2)
    show("T", teacher)
    show("P", player3)
    show("C", chessPlayer2)
    show("TC", teacherPlayingChess.asInstanceOf[IHuman])
    show("TC", teacherPlayingChess.asInstanceOf[ITeacher])
    show("TC", teacherPlayingChess.asInstanceOf[IPlayer])
    show("TC", teacherPlayingChess.asInstanceOf[IChessPlayer])

    println("----------Testing Quake student---------")
    var human3: IHumanUse = new Human("Jonas", "Jonaitis")
    var student2: IStudentUse = new Student(human3, 4)
    var studentPlayingQuake = new StudentPlayingQuake(
        student2, quakePlayer)
    show("H", human3)
    show("S", student2)
    show("P", player2)
    show("Q", quakePlayer)
    show("SQ", studentPlayingQuake.asInstanceOf[IHuman])
    show("SQ", studentPlayingQuake.asInstanceOf[IStudent])
    show("SQ", studentPlayingQuake.asInstanceOf[IPlayer])
    show("SQ", studentPlayingQuake.asInstanceOf[IQuakePlayer])

    println("End.")
  }

}