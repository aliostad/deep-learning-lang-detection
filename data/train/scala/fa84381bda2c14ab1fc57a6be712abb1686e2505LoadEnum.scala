package com.pharbers.datacalc.manager.common

object LoadEnum {
    /**********************************管理员**************************************/
    object title_data extends LoadEnumDefines(0, "读取title中文")//读取医院数据库（中文）
    object field_data extends LoadEnumDefines(1, "读取title英文")//读取医院数据库（英文）
    
    object title_match extends LoadEnumDefines(2, "读取title中文")//读取样本医院（中文）
    object field_match extends LoadEnumDefines(3, "读取title英文")//读取样本医院（英文）
    
    object title_market_data extends LoadEnumDefines(4, "读取title中文")//读取市场（中文）
    object field_market_data extends LoadEnumDefines(5, "读取title英文")//读取市场（英文）
    
    object title_product_data extends LoadEnumDefines(6, "读取title中文")//读取产品（中文）
    object field_product_data extends LoadEnumDefines(7, "读取title英文")//读取产品（英文）
    
    /************************************用户**************************************************/
    object title_cpa_product_data extends LoadEnumDefines(8, "读取title中文")//读取CPA产品（中文）
    object field_cpa_product_data extends LoadEnumDefines(9, "读取title英文")//读取CPA产品（英文）
    
    object title_cpa_market_data extends LoadEnumDefines(10, "读取title中文")//读取CPA市场（中文）
    object field_cpa_market_data extends LoadEnumDefines(11, "读取title英文")//读取CPA市场（英文）
    
    object title_pha_product_data extends LoadEnumDefines(12, "读取title中文")//读取Pha产品（中文）
    object field_pha_product_data extends LoadEnumDefines(13, "读取title英文")//读取Pha产品（英文）
    
    object title_pha_market_data extends LoadEnumDefines(14, "读取title中文")//读取Pha市场（中文）
    object field_pha_market_data extends LoadEnumDefines(15, "读取title英文")//读取Pha市场（英文）
}

sealed case class LoadEnumDefines(val t : Int, val des : String)