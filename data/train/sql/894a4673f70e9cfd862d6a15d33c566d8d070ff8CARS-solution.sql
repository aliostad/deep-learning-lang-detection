set feedback on
column bestmileage format 99.999

--1st query--
select avg(mpg)
from countries, car_makers, model_list, car_names, cars_data
where countryname = 'france' and countryid = country and
car_makers.id = model_list.maker and model_list.model = car_names.model and
car_names.id = cars_data.id and year between 1975 and 1980
;

--2nd query--
select avg(mpg), avg(accelerate), avg(edispl)
from countries, car_makers, model_list, car_names, cars_data, continents
where countryname = 'france' and countryid = country and
car_makers.id = model_list.maker and model_list.model = car_names.model and
car_names.id = cars_data.id and year = 1976 and
continents.continent = 'europe' and continents.contid = countries.continent
;

--3rd query--
select sub.make, sub.year, sub.accelerate
from (select max(accelerate), make, year,
      accelerate, model_list.model
      from model_list, car_names, cars_data
      where model_list.model = car_names.model and
      car_names.id = cars_data.id
      group by model_list.model, accelerate, year, make
      order by max(accelerate)) sub
where rownum = 1
;

--4th query--
select *
from (select max(subcars.avgMileage) as bestMileage, subcars.maker as maker, subcars.numModels as numModels
      from (select avg(MPG) as avgMileage, car_makers.maker as maker, count(*) as numModels
            from car_makers, model_list, car_names, cars_data
            where car_makers.id = model_list.maker and
            model_list.model = car_names.model and
            car_names.id = cars_data.id and year = 1977
            group by car_makers.maker) subcars, car_makers
      where car_makers.maker = subcars.maker and
      subcars.numModels in (select count(*) as numModels
                            from car_makers, model_list, car_names, cars_data
                            where car_makers.id = model_list.maker and
                            model_list.model = car_names.model and
                            car_names.id = cars_data.id and year = 1977
                            group by car_makers.maker)
      group by subcars.numModels, subcars.maker
      order by max(subcars.avgMileage) desc)
where rownum = 1
;

--5th query--
select subtable.year, subtable.mods as numModels,
subtable.mileage, subtable.maker
from (select avg(MPG) as mileage, count(*) as mods,
      cars_data.year as year, car_makers.maker as maker
      from cars_data, car_names, model_list, car_makers
      where cars_data.id = car_names.id and
      car_names.model = model_list.model and
      model_list.maker = car_makers.id
      group by model_list.model, cars_data.year, car_makers.maker
      order by cars_data.year) subtable,
     (select max(data.mileage) as bestmileage, data.year as year
      from (select avg(MPG) as mileage, cars_data.year as year
            from cars_data, car_names, model_list
            where cars_data.id = car_names.id and
            car_names.model = model_list.model
            group by model_list.model, cars_data.year
            order by cars_data.year) data
      group by data.year) subtable2
where subtable.mileage = subtable2.bestmileage and
subtable.year = subtable2.year
--group by subtable.year, subtable.mods, subtable.mileage, subtable.maker
order by subtable.year
;

--6th query--
select car_names.make, cars_data.year, countries.countryname, cars_data.mpg
from cars_data, car_names, model_list, car_makers, countries
where cars_data.id = car_names.id and
car_names.model = model_list.model and
model_list.maker = car_makers.id and
car_makers.country = countries.countryid and
cars_data.mpg in (select min(fuel.mpg)
                  from (select mpg
                        from cars_data
                        where cylinders = 4) fuel)
;

--7th query--
select car_makers.maker, car_names.make, year, weight
from cars_data, car_names, model_list, car_makers, countries
where cars_data.id = car_names.id and
car_names.model = model_list.model and
model_list.maker = car_makers.id and
car_makers.country = countries.countryid and
countries.countryname = 'usa' and
(cars_data.weight, car_makers.id) in (select min(weight), model_list.maker
                                      from cars_data, car_names, model_list
                                      where cars_data.id = car_names.id and
                                      car_names.model = model_list.model
                                      group by model_list.maker)
group by car_makers.maker, car_names.make, year, weight
;

--8th query--
select count(*)
from cars_data, car_names, model_list, car_makers, countries
where cars_data.id = car_names.id and
car_names.model = model_list.model and
model_list.maker = car_makers.id and
car_makers.country = countries.countryid and
cylinders = 4 and year between 1970 and 1979 and
horsepower > some (select horsepower
                   from cars_data
                   where cylinders = 8 and year between 1970 and 1979)
group by countries.countryname
;
