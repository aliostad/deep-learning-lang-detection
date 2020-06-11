INSERT INTO tmp_callerid (
	mode,
	callerdisplay,
	type,
	typeval)
SELECT
	'append',
	callfilter.callerdisplay,
	'callfilter',
	callfilter.id
FROM callfilter;

INSERT INTO tmp_callfilter (
	id,
	name,
	context,
	type,
	bosssecretary,
	callfrom,
	ringseconds,
	commented,
	description)
SELECT
	callfilter.id,
	callfilter.name,
	'default',
	callfilter.type,
	callfilter.bosssecretary,
	callfilter.zone,
	callfilter.ringseconds,
	callfilter.commented,
	callfilter.description
FROM callfilter;

INSERT INTO tmp_contextmember (
	context,
	type,
	typeval,
	varname)
SELECT
	tmp_callfilter.context,
	'callfilter',
	tmp_callfilter.id,
	'context'
FROM tmp_callfilter;
