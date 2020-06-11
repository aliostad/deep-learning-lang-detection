-- TO BE RETIRED, use from dbscripts/schema.sql --

CREATE TABLE vol_surface (
vol_surface_id INTEGER(10) NOT NULL AUTO_INCREMENT,
vol_surface_type VARCHAR(200) NOT NULL,
PRIMARY KEY (vol_surface_id)
)ENGINE=INNODB;


CREATE TABLE VOL_DUMP(
vol_dump_id INTEGER(10) NOT NULL AUTO_INCREMENT,
product VARCHAR(200),
vol_surface_id INTEGER(10),
start DECIMAL(10,2),
step DECIMAL(10,2),
extrapolate VARCHAR(1), 
multiple DECIMAL(10,2),
code VARCHAR(200),
future_ref VARCHAR(200),
options_ref  VARCHAR(200),
expiry_date DATE,
PRIMARY KEY (vol_dump_id)
) ENGINE=INNODB;

ALTER TABLE VOL_DUMP ADD FOREIGN KEY (vol_surface_id) REFERENCES vol_surface (vol_surface_id);

CREATE TABLE instrument (
instrument_id INTEGER(10) NOT NULL AUTO_INCREMENT,
instrument_name VARCHAR(200) NOT NULL,
instrument_code VARCHAR(200),
portfolio  VARCHAR(200), 
maturity VARCHAR(200), 
start_value DECIMAL(10,2),
end_value DECIMAL(10,2),
multiple DECIMAL(10,2),
PRIMARY KEY (instrument_id)
)ENGINE=INNODB;


CREATE TABLE M_US_DUMP(
m_us_dump_id INTEGER(10) NOT NULL AUTO_INCREMENT,
instrument_id  INTEGER(10), 
strike_code VARCHAR(200),
market_value DECIMAL(10,2),
book_value DECIMAL(10,2),
market_us DECIMAL(10,2),
strike_price    DECIMAL(10,2),  
strike_total DECIMAL(10,2),
market_val_call DECIMAL(10,2),
market_cal_put DECIMAL(10,2),
options_expiry_date    DATETIME,  
instrument_display  VARCHAR(200),
PRIMARY KEY (m_us_dump_id )
) ENGINE=INNODB;

ALTER TABLE M_US_DUMP ADD FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id );



CREATE TABLE OPT_DUMP(
opt_dump_id INTEGER(10) NOT NULL AUTO_INCREMENT,
instrument_id  INTEGER(10), 
active_lots  INTEGER(10),
month INTEGER(10), 
strike DECIMAL(10,2),
c_p DECIMAL(10,2),
prem DECIMAL(10,2),
orig_lots DECIMAL(10,2),
portfolio VARCHAR(200), 
multiple DECIMAL(10,2),
lots_for_pivot DECIMAL(10,2),
counterparty VARCHAR(200), 
duplicated  VARCHAR(200),
internal VARCHAR(100),
trn VARCHAR(200),
trn_date   DATETIME,
buy_sell VARCHAR(1), 
initial_qty INTEGER(10),
contract_maturity   VARCHAR(200), 
call_put VARCHAR(1),
stl_prm DECIMAL(10,2),
counterpart_label  VARCHAR(200),  
live_qty INTEGER(10),
PRIMARY KEY (opt_dump_id)
)ENGINE=INNODB;

ALTER TABLE OPT_DUMP ADD FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id );

CREATE TABLE FUT_DUMP(
fut_dump_id INTEGER(10) NOT NULL AUTO_INCREMENT,
instrument_id  INTEGER(10), 
book_value DECIMAL(10,2),
net_pos DECIMAL(10,2),
fut_price DECIMAL(10,2),
contract VARCHAR(200),
fut_settlement DECIMAL(10,2),
adapted_delta DECIMAL(10,2),
gamma_smt DECIMAL(10,2),
theta DECIMAL(10,2),
vega DECIMAL(10,2),
PRIMARY KEY (fut_dump_id)
) ENGINE=INNODB;

ALTER TABLE FUT_DUMP ADD FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id );

