package semverfi

trait Show[T <: SemVersion] {
  def show(v: T): String
}

object Show {
  implicit object ShowNormal extends Show[NormalVersion] {
    def show(v: NormalVersion) = "%d.%d.%d" format(
      v.major, v.minor, v.patch
    )
  }

  implicit object ShowPreRelease extends Show[PreReleaseVersion] {
    def show(v: PreReleaseVersion) = "%d.%d.%d-%s" format(
      v.major, v.minor, v.patch, v.classifier.mkString(".")
    )
  }

  implicit object ShowBuild extends Show[BuildVersion] {
    def show(v: BuildVersion) = "%d.%d.%d%s+%s" format(
      v.major, v.minor, v.patch,
      v.classifier match {
        case Nil => ""
        case cs => cs.mkString("-", ".", "")
      },
      v.build.mkString(".")
    )
  }

  implicit object ShowInvalid extends Show[Invalid] {
    def show(v: Invalid) = "invalid: %s" format v.raw
  }

  implicit object ShowSemVersion extends Show[SemVersion] {
    def show(v: SemVersion) = v match {
      case x: NormalVersion => implicitly[Show[NormalVersion]].show(x)
      case x: PreReleaseVersion => implicitly[Show[PreReleaseVersion]].show(x)
      case x: BuildVersion => implicitly[Show[BuildVersion]].show(x)
      case x: Invalid => implicitly[Show[Invalid]].show(x)
    }
  }

  def apply[T <: SemVersion: Show](v: T) =
    implicitly[Show[T]].show(v)
}
