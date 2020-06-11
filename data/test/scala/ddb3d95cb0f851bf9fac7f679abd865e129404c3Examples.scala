package examples.reactive.monads

import examples.models.AgeStatistics

object Examples {
  object OptionExample {
    val statistics: AgeStatistics = AgeStatistics(20 -> 4, 30 -> 17)

    val twentyYearOldCount: Option[Int] = statistics.get(20)
    val thirtyYearOldCount: Option[Int] = statistics.get(30)

    val twentyAndThirtyYearOldCount: Option[Int] =
      twentyYearOldCount.flatMap(twenties =>
        thirtyYearOldCount.map(thirties => twenties + thirties))
    // twentyAndThirtyYearOldCount hat den Wert Some(21)
  }

  object ForComprehensionExample {
    val statistics: AgeStatistics = AgeStatistics(20 -> 4, 30 -> 17)

    val twentyYearOldCount: Option[Int] = statistics.get(20)
    val thirtyYearOldCount: Option[Int] = statistics.get(30)

    val twentyAndThirtyYearOldCount = for {
      twenties <- twentyYearOldCount
      thirties <- thirtyYearOldCount
    } yield twenties + thirties
    // twentyAndThirtyYearOldCount hat den Wert Some(21)
  }
}