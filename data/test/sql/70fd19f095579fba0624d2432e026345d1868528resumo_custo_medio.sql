-- Function: resumo_custo_medio(character varying)

DROP FUNCTION resumo_custo_medio(character varying);

CREATE OR REPLACE FUNCTION resumo_custo_medio(IN data_limite character varying)
  RETURNS TABLE(location_id integer, product_id integer, data date, entrada numeric, saida numeric, vr_unitario_custo numeric, vr_total numeric, quantidade numeric) AS
$BODY$
from copy import copy
from decimal import Decimal as D
from pybrasil.data import parse_datetime

data = parse_datetime(data_limite)

res = []
linha_modelo = {
  'location_id': 0,
  'product_id': 0,
  'data': None,
  'entrada': D(0),
  'saida': D(0),
  'quantidade': D(0),
  'vr_unitario_custo': D(0),
  'vr_total': D(0),
}

location_id_anterior = 0
product_id_anterior = 0

ent = D(0)
sai = D(0)
vr_unit_custo = D(0)
vr_tot = D(0)
quant = D(0)

for dados in plpy.cursor("select location_id, product_id, data, cast(vr_unitario_custo as varchar), cast(vr_total as varchar), cast(quantidade as varchar), cast(entrada as varchar) as entrada, cast(saida as varchar) as saida from custo_medio() where data <= '%s'" % str(data)[:10]):
    location_id = dados['location_id']
    product_id = dados['product_id']
    data = dados['data']
    vr_unit_custo = D(dados['vr_unitario_custo'])
    vr_tot = D(dados['vr_total'])
    quant = D(dados['quantidade'])
    ent += D(dados['entrada'])
    sai += D(dados['saida'])

    if location_id_anterior == 0:
        location_id_anterior = location_id

    if product_id_anterior == 0:
        product_id_anterior = product_id

    if product_id != product_id_anterior or location_id != location_id_anterior:
        linha = copy(linha_modelo)
        linha['location_id'] = location_id_anterior
        linha['product_id'] = product_id_anterior
        linha['data'] = data
        linha['entrada'] = ent
        linha['saida'] = sai
        linha['vr_unitario_custo'] = vr_unit_custo
        linha['vr_total'] = vr_tot
        linha['quantidade'] = quant
        res.append(linha)
        ent = D(0)
        sai = D(0)
        product_id_anterior = product_id
        location_id_anterior = location_id

#
# Última linha
#
linha = copy(linha_modelo)
linha['location_id'] = location_id_anterior
linha['product_id'] = product_id_anterior
linha['data'] = data
linha['entrada'] = ent
linha['saida'] = sai
linha['vr_unitario_custo'] = vr_unit_custo
linha['vr_total'] = vr_tot
linha['quantidade'] = quant
res.append(linha)

return res
$BODY$
  LANGUAGE plpythonu VOLATILE
  COST 100
  ROWS 1000;

