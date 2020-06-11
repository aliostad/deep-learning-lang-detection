package com.burchnet.stock.portfolio.service

import com.burchnet.stock.portfolio.domain._

class BrokerService {
  def managePortfolioChanges(actions: List[BrokerAction]): List[Stock] = {
      actions.foldLeft(List.empty[Stock])((result, next) =>{
       next match {
        case Sell(number, stock) =>
          println(s"Selling $number units of ${stock.symbol}")
          stock.copy(numberOfShares = stock.numberOfShares - number) :: result
        case Buy(number, stock) =>
          println(s"Buying $number units of ${stock.symbol}")
          stock.copy(numberOfShares = stock.numberOfShares + number) :: result
        case Nothing(stock) =>
          println(s"Do nothing for ${stock.symbol}")
          stock :: result
      }
    })
  }
}