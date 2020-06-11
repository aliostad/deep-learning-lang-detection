package com.ofx.institutions

import com.webcohesion.ofx4j.client.InvestmentAccount
import com.webcohesion.ofx4j.domain.data.investment.accounts.InvestmentAccountDetails

trait InvestmentInstitution extends Institution[InvestmentAccount] {
  val brokerId: String

  override def getAccount(accountNumber: String, username: String, password: String): InvestmentAccount = {
    institutionData.setBrokerId(brokerId)
    val details = new InvestmentAccountDetails()
    details.setBrokerId(institutionData.getBrokerId)
    details.setAccountNumber(accountNumber)
    client.loadInvestmentAccount(details, username, password)
  }
}