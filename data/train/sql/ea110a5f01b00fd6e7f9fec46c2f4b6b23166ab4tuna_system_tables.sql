
create sequence system.tuna_mod minvalue 1 maxvalue 99 cycle;

create table system.tables (
  name name not null,
  mod integer default nextval('system.tuna_mod'::regclass) not null unique
);

create table system.config (
	tuna_max_tables integer not null default 128,
	id_sufix varchar not null default '_id',
	last_redesign timestamp not null default now()
);

insert into system.config (last_redesign) values(now());

/*
  OVO JE IZMJENJENI TABLE_FIELDS, TREBALO BI GA DODATI U TUNU.
  DODANO MU JE SCHEMA NAME. 
*/
create view system.table_fields as
	select 
			c.relname as "tb_name",
			s.mod as "tb_mod",
			a.attname as "field_name",
			a.attnum as "field_order",
			t.typname as "type_name",
			a.atttypid as "type_oid",
			n.nspname as "nsp_name"
		from pg_catalog.pg_attribute a
			join pg_catalog.pg_class c on a.attrelid = c.oid
			left join system.tables s on s.name = c.relname
			join pg_catalog.pg_type t on a.atttypid = t.oid
			join pg_catalog.pg_namespace n on n.oid = c.relnamespace
		where
			a.attnum > 0
			and not a.attisdropped
			and pg_catalog.pg_table_is_visible(c.oid)
			and 
        -- jeli njen namespace u search path-u?
        ('{' || n.nspname || '}')::name[]
          <@
        (select ('{' || setting || '}')::name[] from pg_settings where name = 'search_path')
			and c.relkind = 'r'::char;

create aggregate system.array_accum(anyelement) (
    sfunc = array_append,
    stype = anyarray,
    initcond = '{}'
);


