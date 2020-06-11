package com.pharbers.datacalc.manager.maxmessage

import excel.model.Manage.AdminHospitalDataBase
import excel.model.Manage.AdminHospitalMatchingData
import excel.model.Manage.AdminMarket
import excel.model.CPA.CpaMarket

object DataMessage {
//    case class admin_hosp(file: String) extends CommonMessage
//    
//    case class admin_hosp_match(file: String) extends CommonMessage
//    
//    case class admin_market(file: String) extends CommonMessage
//    
//    case class user_market(file: String) extends CommonMessage
    
    case class Madmin_hosp_data(hosp_data: Option[Stream[AdminHospitalDataBase]]) extends CommonMessage

    case class Madmin_hosp_match(hosp_match_data: Option[Stream[AdminHospitalMatchingData]]) extends CommonMessage
    
    case class Madmin_markets(admin_market: Option[Stream[AdminMarket]]) extends CommonMessage
    
    case class Muser_market(user_market_data: Option[Stream[CpaMarket]]) extends CommonMessage
}