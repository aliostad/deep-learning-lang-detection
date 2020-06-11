package com.pharbers.datacalc.manager.maxmessage

import excel.model.modelRunData
import excel.model.Manage.AdminHospitalDataBase
import excel.model.Manage.AdminHospitalMatchingData
import excel.model.Manage.AdminMarket
import excel.model.CPA.CpaMarket

trait MessageDefines

abstract class CommonMessage extends MessageDefines

case class MarketMessageRoutes(list: List[MessageDefines], 
                                  hosp_data: Option[Stream[AdminHospitalDataBase]], 
                                  hosp_match_data: Option[Stream[AdminHospitalMatchingData]], 
                                  admin_market: Option[Stream[AdminMarket]], 
                                  user_market: Option[Stream[CpaMarket]])

//case class MarketMessageRoutes(list: List[MessageDefines], data: Any)

case class excute(maxObj: MarketMessageRoutes)

case class error()

case class timeout()

case class resultModelRun(res: Option[Stream[modelRunData]])

//case class resultAdminHospData(res: Option[Stream[AdminHospitalDataBase]])
//
//case class resultAdminHospMatchData(res: Option[Stream[AdminHospitalMatchingData]])
//
//case class resultAdminMarketData(res: Option[Stream[AdminMarket]])
//
//case class resultUserMarketData(res: Option[Stream[CpaMarket]])