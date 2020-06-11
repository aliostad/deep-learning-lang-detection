-- DVA Alternativni dotazy
set autotrace on;
select distinct r.*
from
  vypujceni v
  join ridici r on v.ridic_id = r.ridic_id
  join vozidlo vo on v.vozidlo_id = vo.vozidlo_id
  join model m on m.model_id = vo.model_id
where
  m.znacka = 'MAN'
;

select distinct r.* from ridici r, vozidlo v, model m where m.znacka = 'MAN';

set autotrace on;
select
  v.datum_vypujceni
  ,m.znacka || ' ' || m.model vozidlo_model
  ,vo.spz
  ,r.prijmeni || ' ' || r.jmeno jmeno
  ,v.vzdalenost_celkem
from
  vypujceni v
  join ridici r on v.ridic_id = r.ridic_id
  join vozidlo vo on v.vozidlo_id = vo.vozidlo_id
  join model m on m.model_id = vo.model_id
order by
  v.vzdalenost_celkem desc
;

select vyp.datum_vypujceni
  ,m.znacka || ' ' || m.model vozidlo_model
  ,v.spz
  ,r.prijmeni || ' ' || r.jmeno jmeno
  ,vyp.vzdalenost_celkem
  from vypujceni vyp, ridici r, vozidlo v, model m 
  where m.model_id = v.model_id AND v.vozidlo_id = vyp.vozidlo_id AND vyp.ridic_id = r.ridic_id
  order by vyp.vzdalenost_celkem desc;