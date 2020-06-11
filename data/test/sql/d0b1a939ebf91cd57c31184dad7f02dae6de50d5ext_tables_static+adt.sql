#
# Table structure for table 'tx_mminteractive_domain_model_event'
#
DROP TABLE IF EXISTS tx_mminteractive_domain_model_event;

CREATE TABLE tx_mminteractive_domain_model_event (
  uid int(11) unsigned NOT NULL auto_increment,
  pid int(11) unsigned NOT NULL default '0',
	title varchar(255) NOT NULL default '',
  PRIMARY KEY (uid)
);

INSERT INTO tx_mminteractive_domain_model_event VALUES ('1', '0', 'none');
INSERT INTO tx_mminteractive_domain_model_event VALUES ('2', '0', 'mouseover');
INSERT INTO tx_mminteractive_domain_model_event VALUES ('3', '0', 'mouseout');
INSERT INTO tx_mminteractive_domain_model_event VALUES ('4', '0', 'mouseup');
INSERT INTO tx_mminteractive_domain_model_event VALUES ('5', '0', 'mousedown');
INSERT INTO tx_mminteractive_domain_model_event VALUES ('6', '0', 'mousemove');
INSERT INTO tx_mminteractive_domain_model_event VALUES ('7', '0', 'mouseclick');