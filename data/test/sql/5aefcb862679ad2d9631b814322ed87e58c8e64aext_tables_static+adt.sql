
CREATE TABLE tx_t3m_salutations (
  uid int(11) NOT NULL auto_increment,
  pid int(11) NOT NULL default '0',
  tstamp int(11) NOT NULL default '0',
  crdate int(11) NOT NULL default '0',
  cruser_id int(11) NOT NULL default '0',
  deleted tinyint(4) NOT NULL default '0',
  hidden tinyint(4) NOT NULL default '0',
  name tinytext NOT NULL,
  single_female text NOT NULL,
  single_male text NOT NULL,
  plural text NOT NULL,
  sys_language_uid int(11) NOT NULL default '0',
  l18n_parent int(11) NOT NULL default '0',
  l18n_diffsource mediumblob NOT NULL,
  sorting int(10) NOT NULL default '0',
  include_first_name tinyint(3) NOT NULL default '0',
  include_last_name tinyint(3) NOT NULL default '0',
  append_comma tinyint(3) NOT NULL default '0',
  append tinytext NOT NULL,

  PRIMARY KEY  (uid),
  KEY parent (pid)
)  ;


INSERT INTO tx_t3m_salutations VALUES (1, 139, 1165483416, 1160918024, 2, 0, 0, 'Sehr geehrte ...', 'Sehr geehrte Frau', 'Sehr geehrter Herr', 'Sehr geehrte Damen und Herren', 0, 0, 'a:9:{s:16:"sys_language_uid";N;s:6:"hidden";N;s:4:"name";N;s:13:"single_female";N;s:11:"single_male";N;s:6:"plural";N;s:18:"include_first_name";N;s:17:"include_last_name";N;s:6:"append";N;}', 512, 0, 1, 1, ',');
INSERT INTO tx_t3m_salutations VALUES (2, 139, 1165483407, 1160951558, 2, 0, 0, 'Hallo Frau und Herr', 'Hallo Frau', 'Hallo Herr', 'Hallo', 0, 0, 'a:9:{s:16:"sys_language_uid";N;s:6:"hidden";N;s:4:"name";N;s:13:"single_female";N;s:11:"single_male";N;s:6:"plural";N;s:18:"include_first_name";N;s:17:"include_last_name";N;s:6:"append";N;}', 256, 0, 1, 0, '!');
INSERT INTO tx_t3m_salutations VALUES (3, 139, 1165483395, 1161050687, 2, 0, 0, 'Lieber/Liebe', 'Liebe Frau', 'Lieber Herr', 'Liebe Interessenten', 0, 0, 'a:9:{s:16:"sys_language_uid";N;s:6:"hidden";N;s:4:"name";N;s:13:"single_female";N;s:11:"single_male";N;s:6:"plural";N;s:18:"include_first_name";N;s:17:"include_last_name";N;s:6:"append";N;}', 128, 0, 1, 0, ',');
INSERT INTO tx_t3m_salutations VALUES (4, 139, 1165483388, 1165475099, 2, 0, 0, 'Dear', 'Dear Mrs.', 'Dear Mr.', 'Dear Ladies and Gentlemen', 0, 0, 'a:9:{s:16:"sys_language_uid";N;s:6:"hidden";N;s:4:"name";N;s:13:"single_female";N;s:11:"single_male";N;s:6:"plural";N;s:18:"include_first_name";N;s:17:"include_last_name";N;s:6:"append";N;}', 64, 0, 1, 1, ',');
INSERT INTO tx_t3m_salutations VALUES (5, 139, 1165483372, 1165477913, 2, 0, 0, 'Hallo', 'Hallo', 'Hallo', 'Hallo', 0, 0, 'a:9:{s:16:"sys_language_uid";N;s:6:"hidden";N;s:4:"name";N;s:13:"single_female";N;s:11:"single_male";N;s:6:"plural";N;s:18:"include_first_name";N;s:17:"include_last_name";N;s:6:"append";N;}', 32, 1, 0, 0, '!');
