module Commafy
  class Commafy < Grape::API
    desc 'Returns the number commafied using the chunk'
    params do
      requires :number, type: String, desc: 'Number to parse'
      requires :chunk, type: Integer, desc: 'Chunks'
    end
    get '/commafy/:number/:chunk',
      :requirements => { :number => /[^\/]+/i } do
      original = Parser.numberize_string(declared(params)[:number])
      chunk = declared(params)[:chunk]
      commafied = ::Parser.parse(original, chunk)

      {
        original: original,
        commafied: commafied
      }
    end
  end
end
