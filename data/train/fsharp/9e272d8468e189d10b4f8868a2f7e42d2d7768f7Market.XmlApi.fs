namespace FunEve.MarketDomain

module MarketXmlApi = 
    let XmlApiEndpoint = "https://api.eveonline.com"
    let keyId = "5818284"
    let vCode = "p9s2gs0mZ9NPwZnd1FV7yaXJ7LV1a73OZerbm62xU8s0zjfCiQmgXGwOdN2O419X"
    let characterId = "96868921"
    let corp_keyId = "6087058"
    let corp_vCode = "aQ7vRp0jmlsGYaTgmByv4I4A1ns8GU0kJtuk7uQeShJhhaympQk0AWfuoIrauc4K"
    
    let formApiUrl () = 
        // sprintf "%s%s" XmlApiEndpoint @"/account/APIKeyInfo.xml.aspx"
        // |> fun url -> sprintf @"%s?keyID=%s&vCode=%s" url keyId vCode
        let url = XmlApiEndpoint + @"/corp/MarketOrders.xml.aspx"
        let rtttttt = 
            sprintf @"%s?keyID=%s&vCode=%s&characterID=%s" url corp_keyId corp_vCode characterId
        
        let test2val = eZet.EveLib.EveXmlModule.EveXml.CreateCorporation(int64 corp_keyId, corp_vCode, int64 characterId)
        
        let rrr = test2val.GetMarketOrders()




        rrr

