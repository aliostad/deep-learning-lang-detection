set feedback on

--1st query--
select avg(MPG)
from cars_data
where cylinders = 8 and year between 1970 and 1979
;

--2nd query--
select year, avg(Edispl)
from countries, car_makers, cars_data, model_list, car_names
where countryname = 'usa' and countryid = country and
car_makers.id = model_list.maker and model_list.model = car_names.model and
car_names.id = cars_data.id
group by year
order by year asc
;

--3rd query--
select min(weight)
from cars_data, continents, countries, model_list, car_makers, car_names
where continents.continent = 'europe' and contid = countries.continent and
countryid = car_makers.country and car_makers.id = model_list.maker and
model_list.model = car_names.model and car_names.id = cars_data.id
;

--4th query--
select count(*)
from car_names, car_makers, cars_data, model_list, countries
where countryname != 'usa' and countryid = car_makers.country and
car_makers.id = model_list.maker and model_list.model = car_names.model and
car_names.id = cars_data.id and cylinders = 4 and year between 1970 and 1977
group by car_makers.fullname
order by count(*) asc
;

--5th query--
select max(accelerate), min(accelerate), count(*)
from car_names, car_makers, cars_data, model_list, countries
where countryname = 'usa' and countryid = car_makers.country and
car_makers.id = model_list.maker and model_list.model = car_names.model and
car_names.id = cars_data.id and year = 1975
group by car_makers.fullname
order by car_makers.fullname asc
;

--6th query--
select max(q2.fordweight), min(q2.fordweight), avg(q2.fordweight)
from (select count(*) as numModels, gmcars.gmweight as fordweight, gmcars.gmyear as years
      from (select cars_data.weight as gmWeight, cars_data.year as gmYear,
            car_names.model as gmModel
           from car_makers, model_list,
           cars_data, car_names
            where car_makers.id = model_list.maker and
            model_list.model = car_names.model and
            car_names.model = 'ford' and
            car_names.id = cars_data.id and car_makers.maker = 'gm') gmCars,
      model_list, car_names, car_makers
      where car_makers.maker = 'gm' and car_names.model = model_list.model and
      car_names.model = gmcars.gmmodel and car_makers.id = model_list.maker
      group by gmCars.gmYear, gmcars.gmweight, gmcars.gmyear) q2
where q2.numModels > 8
group by q2.years
order by q2.years
;

--7th query--
select count(*)
from car_makers cm, model_list ml, car_names cn, cars_data cd, countries
where cm.country = countries.countryid and countries.countryname = 'usa' and
cm.id = ml.maker and ml.model = cn.model and cn.id = cd.id and
year between 1976 and 1982
group by year, cm.maker
order by year, cm.maker
;

--8th query--
select c.countryname, count(*)
from countries c, car_makers cm, model_list ml, car_names cn, cars_data cd
where c.countryid = cm.country and cm.id = ml.maker and
ml.model = cn.model and cn.id = cd.id and cd.year = 1979
group by c.countryname
;
