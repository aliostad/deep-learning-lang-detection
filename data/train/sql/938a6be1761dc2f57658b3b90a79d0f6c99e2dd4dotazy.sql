--1.Vypise vsechny ridice, kteri najezdili vice jak 35000km
SET AUTOTRACE ON;
select
  * 
from 
  ridici
where 
  ridic_id in 
  (
    select 
      ridic_id 
    from 
      vypujceni 
    group by 
      ridic_id
    having 
      sum(vzdalenost_celkem) >= 35000
  );

--2.Vypise automobil a model (podle ujetych kilometru) a jejich model.
SET AUTOTRACE ON;
select
  m.znacka
  ,m.model
  ,v.spz
  ,t.celkem
from
  vozidlo v
  join model m on v.model_id = m.model_id
  join
  (
  select
    vozidlo_id
    ,sum(vzdalenost_celkem) celkem
  from
    vypujceni
  group by
    vozidlo_id
  ) t on v.vozidlo_id = t.vozidlo_id
order by
  t.celkem desc;
--3.Vypise vsechny ridice, kteri za leden, unor a brezen roku 2013 udelali alespon 20 jizd
SET AUTOTRACE ON;
select
  ridici.*
from
  (
    select 
      ridic_id
    from
      vypujceni
    where 
      datum_vypujceni >= '1.1.2013' and datum_vypujceni <= '31.3.2013'
    group by
      ridic_id
    having
      count(*) >= 20
  ) t
  join ridici on t.ridic_id = ridici.ridic_id
;
--4.Vypse (vsechny) datum vypujceni, model, sqz a jmeno ridice, podle vzdalenosti, ktrou ujeli na jedno vypujceni.
SET AUTOTRACE ON;
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
--5.Vypse vsechny ridice, kteri ridili vozidlo, model MAN
SET AUTOTRACE ON;
select distinct
  r.*
from
  vypujceni v
  join ridici r on v.ridic_id = r.ridic_id
  join vozidlo vo on v.vozidlo_id = vo.vozidlo_id
  join model m on m.model_id = vo.model_id
where
  m.znacka = 'MAN'
;




