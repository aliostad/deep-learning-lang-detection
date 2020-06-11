# MbgaAPI
module MbgaAPI
  autoload :TextData, 'mbga_api/text_data'
  autoload :BlackList, 'mbga_api/black_list'
  autoload :NgWord, 'mbga_api/ng_word'
  autoload :Payment, 'mbga_api/payment'
  autoload :Activity, 'mbga_api/activity'
  autoload :MbgaAPIException, 'mbga_api/mbga_api_exception'

  class Parse
    #
    # httpレスポンス　データの解析を行う
    # apiName : mbgaAPI名
    # data : httpレスポンスオブジェクト
    def self.execute(apiName, data)
      hashData = JSON.parse(data.body)
      return MbgaAPI::class_eval(apiName).new(data.code, hashData)
    end
  end
end
