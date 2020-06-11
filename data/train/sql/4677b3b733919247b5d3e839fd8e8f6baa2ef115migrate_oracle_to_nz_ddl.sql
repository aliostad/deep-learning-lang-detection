--------------------
-- ${table.full_table_name}
--------------------
--DROP TABLE ${table.full_table_name};
CREATE TABLE ${table.full_table_name}
(
% for c in table.columns:
        ${c},
% endfor
% for c in settings['append_columns']:
        ${c},
% endfor
% if len(table.pks) > 0:
    PRIMARY KEY (${', '.join([i.column_name for i in table.pks])})
% endif
)
% if settings['distribute_on_pk'] == True and len(table.pks) > 0:
    DISTRIBUTE ON (${', '.join([i.column_name for i in table.pks])});
% else:
    DISTRIBUTE ON RANDOM;
% endif
