package com.pharbers.datacalc.manager.common

object xmlOpt {
    /******************************管理员***********************************/
    lazy val hospData = xml.XML.loadFile("config/admin/HospDataStruct.xml")//医院数据库（中文）
    lazy val fieldHospData = xml.XML.loadFile("config/admin/FieldNamesHospDataStruct.xml")//医院数据库（英文）
    lazy val hospMatchData = xml.XML.loadFile("config/admin/HospDataMatchStruct.xml")//样本医院（中文）
    lazy val fieldMatchHospData = xml.XML.loadFile("config/admin/FieldNamesMatchStruct.xml")//样本医院（英文）
    lazy val marketData = xml.XML.loadFile("config/admin/MarketDataStruct.xml")//市场匹配（中文）
    lazy val fieldMarketData = xml.XML.loadFile("config/admin/FieldNamesMarketDataStruct.xml")//市场匹配（英文）
    lazy val productData = xml.XML.loadFile("config/admin/ProductDataStruct.xml")//产品匹配（中文）
    lazy val fieldProductData = xml.XML.loadFile("config/admin/FieldNamesProductDataStruct.xml")//产品匹配（英文）
    
    /********************************用户*************************************/
    lazy val cpaProductData = xml.XML.loadFile("config/consumer/CpaProductDataStruct.xml")//CPA产品（中文）
    lazy val fieldCpaProductData = xml.XML.loadFile("config/consumer/FieldNamesCpaProductDataStruct.xml")//CPA产品（英文）
    lazy val cpaMarketData = xml.XML.loadFile("config/consumer/CpaMarketDataStruct.xml")//CPA市场（中文）
    lazy val fieldCpaMarket = xml.XML.loadFile("config/consumer/FieldNamesCpaMarketDataStruct.xml")//CPA市场（英文）
    
    lazy val phaProductData = xml.XML.loadFile("config/consumer/PhaProductDataStruct.xml")//PHA产品（中文）
    lazy val fieldPhaProductData = xml.XML.loadFile("config/consumer/FieldNamesPhaProductDataStruct.xml")//PHA产品（英文）
    lazy val pahMarketData = xml.XML.loadFile("config/consumer/PhaMarketDataStruct.xml")//PHA市场（中文）
    lazy val fieldPpahMarketData = xml.XML.loadFile("config/consumer/FieldNamesPhaMarketDataStruct.xml")//PHA市场（英文）
    
    def apply(e : Int) : Array[String] = e match {
        case LoadEnum.title_data.t => loadHospDataStruct.toArray
        case LoadEnum.field_data.t => loadFieldNamesHospDataStruct.toArray
        case LoadEnum.title_match.t => loadMatchDataStruct.toArray
        case LoadEnum.field_match.t => loadMatchFieldStruct.toArray
        case LoadEnum.title_market_data.t => loadMarketDataStruct.toArray
        case LoadEnum.field_market_data.t => loadMarketFieldDataStruct.toArray
        case LoadEnum.title_product_data.t => loadProductDataStruct.toArray
        case LoadEnum.field_product_data.t => loadProductFieldDataStruct.toArray
        case LoadEnum.title_cpa_product_data.t => loadCpaProductDataStruct.toArray
        case LoadEnum.field_cpa_product_data.t => loadCpaProductFieldDataStruct.toArray
        case LoadEnum.title_cpa_market_data.t => loadCpaMarketDataStruct.toArray
        case LoadEnum.field_cpa_market_data.t => loadCpaMarketFieldDataStruct.toArray
        case LoadEnum.title_pha_product_data.t => loadPhaProductDataStruct.toArray
        case LoadEnum.field_pha_product_data.t => loadPhaProductFieldDataStruct.toArray
        case LoadEnum.title_pha_market_data.t => loadPhaMarketDataStruct.toArray
        case LoadEnum.field_pha_market_data.t => loadPhaMarketFieldDataStruct.toArray
        case _ => ???
    }
    
    /**
     * 医院数据库（中文字段）
     */
    var loadHospDataStruct_val : List[String] = Nil
    def loadHospDataStruct = {
        if (loadHospDataStruct_val.isEmpty) 
            loadHospDataStruct_val = ((hospData \ "title").map (x => x.text)).toList
        
            loadHospDataStruct_val
    }
    
    /**
     * 医院数据库（英文字段）
     */
    var loadFieldNamesHospDataStruct_val : List[String] = Nil
    def loadFieldNamesHospDataStruct = {
        if (loadFieldNamesHospDataStruct_val.isEmpty) 
            loadFieldNamesHospDataStruct_val = ((fieldHospData \ "title").map (x => x.text)).toList
        
        loadFieldNamesHospDataStruct_val
    }
    
    /**
     * 样本医院匹配（中文字段）
     */
    var loadMatchDataStruct_val : List[String] = Nil
    def loadMatchDataStruct = {
        if (loadMatchDataStruct_val.isEmpty) 
            loadMatchDataStruct_val = ((hospMatchData \ "title").map (x => x.text)).toList
        
            loadMatchDataStruct_val
    }
    
    /**
     * 样本医院匹配（英文字段）
     */
    var loadMatchFieldStruct_val : List[String] = Nil
    def loadMatchFieldStruct = {
        if (loadMatchFieldStruct_val.isEmpty) 
            loadMatchFieldStruct_val = ((fieldMatchHospData \ "title").map (x => x.text)).toList
        
        loadMatchFieldStruct_val
    }
    
    /**
     * 市场匹配（中文字段）
     */
    var loadMarketDataStruct_val : List[String] = Nil
    def loadMarketDataStruct = {
        if(loadMarketDataStruct_val.isEmpty){
           loadMarketDataStruct_val = ((marketData \ "title").map (x => x.text)).toList 
        }
        loadMarketDataStruct_val
    }
    
    /**
     * 市场匹配（英文字段）
     */
    var loadMarketFieldDataStruct_val : List[String] = Nil
    def loadMarketFieldDataStruct = {
        if(loadMarketFieldDataStruct_val.isEmpty){
           loadMarketFieldDataStruct_val = ((fieldMarketData \ "title").map (x => x.text)).toList 
        }
        loadMarketFieldDataStruct_val
    }
    
    /**
     * 产品匹配（中文字段）
     */
    var loadProductDataStruct_val : List[String] = Nil
    def loadProductDataStruct = {
        if(loadProductDataStruct_val.isEmpty){
           loadProductDataStruct_val = ((productData \ "title").map (x => x.text)).toList 
        }
        loadProductDataStruct_val
    }
    
    /**
     * 产品匹配（英文字段）
     */
    var loadProductFieldDataStruct_val : List[String] = Nil
    def loadProductFieldDataStruct = {
        if(loadProductFieldDataStruct_val.isEmpty){
           loadProductFieldDataStruct_val = ((fieldProductData \ "title").map (x => x.text)).toList 
        }
        loadProductFieldDataStruct_val
    }
    
    /**
     * CPA产品（中文字段）
     */
    var loadCpaProductDataStruct_val : List[String] = Nil
    def loadCpaProductDataStruct = {
        if(loadCpaProductDataStruct_val.isEmpty){
           loadCpaProductDataStruct_val = ((cpaProductData \ "title").map (x => x.text)).toList 
        }
        loadCpaProductDataStruct_val
    }
    
    /**
     * CPA产品（英文字段）
     */
    var loadCpaProductFieldDataStruct_val : List[String] = Nil
    def loadCpaProductFieldDataStruct = {
        if(loadCpaProductFieldDataStruct_val.isEmpty){
           loadCpaProductFieldDataStruct_val = ((fieldCpaProductData \ "title").map (x => x.text)).toList 
        }
        loadCpaProductFieldDataStruct_val
    }
    
    /**
     * CPA市场（中文字段）
     */
    var loadCpaMarketDataStruct_val : List[String] = Nil
    def loadCpaMarketDataStruct = {
        if(loadCpaMarketDataStruct_val.isEmpty){
           loadCpaMarketDataStruct_val = ((cpaMarketData \ "title").map (x => x.text)).toList 
        }
        loadCpaMarketDataStruct_val
    } 
    
    /**
     * CPA市场（英文字段）
     */
    var loadCpaMarketFieldDataStruct_val : List[String] = Nil
    def loadCpaMarketFieldDataStruct = {
        if(loadCpaMarketFieldDataStruct_val.isEmpty){
           loadCpaMarketFieldDataStruct_val = ((fieldCpaMarket \ "title").map (x => x.text)).toList 
        }
        loadCpaMarketFieldDataStruct_val
    }
    
    /**
     * PHA产品（中文字段） 
     */
    var loadPhaProductDataStruct_val : List[String] = Nil
    def loadPhaProductDataStruct = {
        if(loadPhaProductDataStruct_val.isEmpty){
           loadPhaProductDataStruct_val = ((phaProductData \ "title").map (x => x.text)).toList 
        }
        loadPhaProductDataStruct_val
    }
    
    /**
     * PHA产品（英文字段）
     */
    var loadPhaProductFieldDataStruct_val : List[String] = Nil
    def loadPhaProductFieldDataStruct = {
        if(loadPhaProductFieldDataStruct_val.isEmpty){
           loadPhaProductFieldDataStruct_val = ((fieldPhaProductData \ "title").map (x => x.text)).toList 
        }
        loadPhaProductFieldDataStruct_val
    }
    
    /**
     * PHA市场（中文字段）  
     */
    var loadPhaMarketDataStruct_val : List[String] = Nil
    def loadPhaMarketDataStruct = {
        if(loadPhaMarketDataStruct_val.isEmpty){
           loadPhaMarketDataStruct_val = ((pahMarketData \ "title").map (x => x.text)).toList 
        }
        loadPhaMarketDataStruct_val
    } 
    
    /**
     * PHA市场（英文字段）
     */
    var loadPhaMarketFieldDataStruct_val : List[String] = Nil
    def loadPhaMarketFieldDataStruct = {
        if(loadCpaMarketFieldDataStruct_val.isEmpty){
           loadCpaMarketFieldDataStruct_val = ((fieldPpahMarketData \ "title").map (x => x.text)).toList 
        }
        loadCpaMarketFieldDataStruct_val
    }
}