require 'net/http'

module Api
  module V1
    class Api::V1::TributariesController < ApplicationController

      def new
        source = "http://localhost:3000/api/v1/tributaries/show"
        resp = Net::HTTP.get_response(URI.parse(source))
        data = resp.body
        api = JSON.parse(data)

        $i = 0
        $api_count = api.count

        #Colocar códigos de erros correto.
        #Testar
        #Melhorar a documentação
        #Colocar no campo mini doc

        while $i < $api_count  do
          tributaries = Tributary.where(id_api: api[$i]['id'])

          if tributaries.blank?
            Tributary.create(
              data_de_vencimento: api[$i]['expire_date'],
              data_do_pagamento: api[$i]['payment_date'],
              numero_do_boleto: api[$i]['number'],
              valor_do_boleto: api[$i]['value'],
              valor_pago: api[$i]['amount'],
              valor_desconto: api[$i]['discount'],
              outra_deducao: api[$i]['another_discount'],
              valor_mora_juro: api[$i]['default_interest'],
              outro_acrescimo: api[$i]['another_addition'],
              link_do_boleto: api[$i]['link_bank_split'],
              id_api: api[$i]['id'],
            )
          end
          $i +=1
        end

        render json: api
      end

      def show
        api = Tributary.all
        render json: api
      end

    end
  end
end
