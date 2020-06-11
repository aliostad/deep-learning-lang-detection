from scraperwiki.sqlite import save, execute

for table_name in ['lowercase', 'uppercase', 'bothcases']:
    execute('DROP TABLE IF EXISTS ' + table_name)

save([], {"CASE": "UPPER"}, 'uppercase')
save([], {"case": "lower"}, 'lowercase')
save([], {"CASE": "UPPER", "case": "lower"}, 'bothcases')from scraperwiki.sqlite import save, execute

for table_name in ['lowercase', 'uppercase', 'bothcases']:
    execute('DROP TABLE IF EXISTS ' + table_name)

save([], {"CASE": "UPPER"}, 'uppercase')
save([], {"case": "lower"}, 'lowercase')
save([], {"CASE": "UPPER", "case": "lower"}, 'bothcases')