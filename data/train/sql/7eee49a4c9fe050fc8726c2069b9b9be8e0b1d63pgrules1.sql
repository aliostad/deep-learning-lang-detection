-- <2010-11-18 Thu 12:56> rpc -  Rules are a special thing, trying to find one that will work for the
-- lack of "REPLACE INTO" in pg, vs mysql

-- <2010-11-18 Thu 12:57> rpc - from http://www.pointwriter.com/blog/index.php?/archives/6-REPLACE-in-PostgreSQL.html
CREATE RULE "replace_quotes1min_outdated_see_below" AS
    ON INSERT TO "quotes1min"
    WHERE
      EXISTS(SELECT 1 FROM quotes1min WHERE symbol=NEW.symbol AND datetime=NEW.datetime)
    DO INSTEAD
       (UPDATE quotes1min SET value=NEW.value WHERE key=NEW.key)

\c mydb
create table map 

CREATE RULE "replace_map" AS
    ON INSERT TO "map"
    WHERE
      EXISTS(SELECT 1 FROM map WHERE key=NEW.key)
    DO INSTEAD
       (UPDATE map SET value=NEW.value WHERE key=NEW.key);

 -- Proof the above works - change the second value randomly in insert below
insert into map values (6, 4);
select * from map;

\c Trading
CREATE RULE "replace_qtest" AS
    ON INSERT TO "qtest"
    WHERE
      EXISTS(SELECT 1 FROM qtest WHERE symbol=NEW.symbol AND datetime=NEW.datetime)
    DO INSTEAD
       (UPDATE qtest SET expiry=NEW.expiry, open=NEW.open, high=NEW.high, low=NEW.low,
       close=NEW.close, volume=NEW.volume WHERE symbol=NEW.symbol AND datetime=NEW.datetime);

CREATE RULE "replace_quotes1min" AS
    ON INSERT TO "quotes1min"
    WHERE
      EXISTS(SELECT 1 FROM quotes1min WHERE symbol=NEW.symbol AND datetime=NEW.datetime)
    DO INSTEAD
       (UPDATE quotes1min SET expiry=NEW.expiry, open=NEW.open, high=NEW.high, low=NEW.low,
       close=NEW.close, volume=NEW.volume WHERE symbol=NEW.symbol AND datetime=NEW.datetime);

CREATE RULE "replace_futuresContractDetails" AS
    ON INSERT TO "futurescontractdetails"
    WHERE
      EXISTS(SELECT 1 FROM futuresContractDetails WHERE symbol=NEW.symbol AND expiry=NEW.expiry)
    DO INSTEAD
       (UPDATE futuresContractDetails SET multiplier=NEW.multiplier,
    pricemagnifier=NEW.pricemagnifier,
    exchange=NEW.exchange, mintick=NEW.mintick, fullname=NEW.fullname
         WHERE symbol=NEW.symbol AND expiry=NEW.expiry);

