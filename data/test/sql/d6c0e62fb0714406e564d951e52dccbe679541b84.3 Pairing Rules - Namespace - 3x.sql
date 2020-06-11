use patstat
go

/*
Those triple argument rules and their queries are derivatives of other doubule rules.
E.g. N1W4W5b pairs can be obtained by intersection of pair set that follows N1W4 rule and N1W5b rule.
Since certain double rules can be omitted in 4.1 and 4.2, the triple rules that are made up of them behave differently.
If all double rules are used, the triple rules scores provide only an additional bonus for scoring on multiple rules.
If some double rules are omitted, triple rules should score the pairs with the point scale established in 4.1 and 4.2.
However, this step can be considered as a simplification of the notion that pairs scored by multiple rules are more valuable than simple addition of rule scores.
As a result, simple bonus can be provided to those pairs irrespective of their previous (lack of) scoring. 
*/

--Strong N + Weak W + Weak W

--N1W4W5a
if object_id('rule_N1W4W5a') is not null drop table rule_N1W4W5a
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_N1W4W5a
from evaluated_patterns as a
join evaluated_patterns as b on
	a.bib_numeric=b.bib_numeric
	and a.bibliographic_type=b.bibliographic_type
	and a.residual=b.residual
where a.new_id < b.new_id
go

--N1W4W5b
if object_id('rule_N1W4W5b') is not null drop table rule_N1W4W5b
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_N1W4W5b
from evaluated_patterns as a
join evaluated_patterns as b on
	a.bib_numeric=b.bib_numeric
	and a.bibliographic_type=b.bibliographic_type
where a.new_id < b.new_id
	and a.residual is not null
	and b.residual is not null
	and (len(a.residual))>=10
	and (len(b.residual))>=10
	and dbo.ComputeDistancePerc(substring(a.residual, ((len(a.residual)/2)-5), 10), substring(b.residual, ((len(b.residual)/2)-5), 10)) >= 0.70
except (select * from rule_N1W4W5a)
go

--Strong N + Middle W + Weak W

--N1W3bW4
if object_id('rule_N1W3bW4') is not null drop table rule_N1W3bW4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_N1W3bW4
from evaluated_patterns as a
join evaluated_patterns as b on
	a.bib_numeric=b.bib_numeric
	and a.bibliographic_type=b.bibliographic_type
where a.new_id < b.new_id
	and a.name is not null
	and b.name is not null
	and a.aetal is null
	and b.aetal is null
	and dbo.ComputeDistancePerc(a.name, b.name) >= 0.70
go

--N1W2bW5b
if object_id('rule_N1W2bW5b') is not null drop table rule_N1W2bW5b
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_N1W2bW5b
from evaluated_patterns as a
join evaluated_patterns as b on
	a.bib_numeric=b.bib_numeric
where a.new_id < b.new_id
	and a.aetal is not null
	and b.aetal is not null
	and dbo.ComputeDistancePerc(a.aetal, b.aetal) >= 0.70
	and a.residual is not null
	and b.residual is not null
	and (len(a.residual))>=10
	and (len(b.residual))>=10
	and dbo.ComputeDistancePerc(substring(a.residual, ((len(a.residual)/2)-5), 10), substring(b.residual, ((len(b.residual)/2)-5), 10)) >= 0.70
go

--N2...

--N2W3bW4
if object_id('rule_N2W3bW4') is not null drop table rule_N2W3bW4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_N2W3bW4
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.issn=b.issn
	or a.isbn=b.isbn)
	and (a.pages_start=b.pages_start
	and a.volume=b.volume
	and a.d_year=b.d_year)
	and a.bibliographic_type=b.bibliographic_type
where a.new_id < b.new_id
go

/*
--N2W3bW5b
if object_id('rule_N2W3bW5b') is not null drop table rule_N2W3bW5b
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_N2W3bW5b
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.issn=b.issn
	or a.isbn=b.isbn)
	and (a.pages_start=b.pages_start
	and a.volume=b.volume
	and a.d_year=b.d_year)
where a.new_id < b.new_id
	and a.residual is not null
	and b.residual is not null
	and (len(a.residual))>=10
	and (len(b.residual))>=10
	and dbo.ComputeDistancePerc(substring(a.residual, ((len(a.residual)/2)-5), 10), substring(b.residual, ((len(b.residual)/2)-5), 10)) >= 0.70
go

*/

--Strong W + Weak N + Weak W

--W1bN3bW4
if object_id('rule_W1bN3bW4') is not null drop table rule_W1bN3bW4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_W1bN3bW4
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.pages_start=b.pages_start
	and a.volume=b.volume
	and a.d_year=b.d_year)
	and a.bibliographic_type=b.bibliographic_type
where a.new_id < b.new_id
	and a.bib_alphabetic is not null
	and b.bib_alphabetic is not null
	and len(a.bib_alphabetic)>=10
	and len(b.bib_alphabetic)>=10
	and dbo.ComputeDistancePerc(substring(a.bib_alphabetic, ((len(a.bib_alphabetic)/2)-5),10), substring(b.bib_alphabetic, ((len(a.bib_alphabetic)/2)-5),10)) >= 0.60
go

--W2aN3bW4
if object_id('rule_W2aN3bW4') is not null drop table rule_W2aN3bW4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_W2aN3bW4
from evaluated_patterns as a
join evaluated_patterns as b on
	a.aetal=b.aetal
	and (a.pages_start=b.pages_start
	and a.volume=b.volume
	and a.d_year=b.d_year)
	and a.bibliographic_type=b.bibliographic_type
where a.new_id < b.new_id
go

--Strong W + Middle N + Weak N

--W1aN3aN4
if object_id('rule_W1aN3aN4') is not null drop table rule_W1aN3aN4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_W1aN3aN4
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.pages_start=b.pages_start
	and a.pages_end=b.pages_end
	and a.volume=b.volume
	and a.issue=b.issue
	and a.d_year=b.d_year
	and a.d_month=b.d_month) --N3a
	and a.bib_alphabetic=b.bib_alphabetic --W1a
	and (a.count_of_numbers=b.count_of_numbers
	and a.sum_of_numbers=b.sum_of_numbers
	and a.count_of_numbers>6
	and b.count_of_numbers>6) --N4
where a.new_id < b.new_id
go

--W1bN3aN4
if object_id('rule_W1bN3aN4') is not null drop table rule_W1bN3aN4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_W1bN3aN4
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.pages_start=b.pages_start
	and a.pages_end=b.pages_end
	and a.volume=b.volume
	and a.issue=b.issue
	and a.d_year=b.d_year
	and a.d_month=b.d_month) --N3a
	and (a.count_of_numbers=b.count_of_numbers
	and a.sum_of_numbers=b.sum_of_numbers
	and a.count_of_numbers>6
	and b.count_of_numbers>6) --N4
where a.new_id < b.new_id
	and a.bib_alphabetic is not null
	and b.bib_alphabetic is not null
	and len(a.bib_alphabetic)>=10
	and len(b.bib_alphabetic)>=10
	and dbo.ComputeDistancePerc(substring(a.bib_alphabetic, ((len(a.bib_alphabetic)/2)-5),10), substring(b.bib_alphabetic, ((len(a.bib_alphabetic)/2)-5),10)) >= 0.60
except (select * from rule_W1aN3aN4)
go

--W2...

--W2aN3aN4
if object_id('rule_W2aN3aN4') is not null drop table rule_W2aN3aN4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_W2aN3aN4
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.pages_start=b.pages_start
	and a.pages_end=b.pages_end
	and a.volume=b.volume
	and a.issue=b.issue
	and a.d_year=b.d_year
	and a.d_month=b.d_month) --N3a
	and a.aetal=b.aetal --W2a
	and (a.count_of_numbers=b.count_of_numbers
	and a.sum_of_numbers=b.sum_of_numbers
	and a.count_of_numbers>6
	and b.count_of_numbers>6) --N4
where a.new_id < b.new_id
go

--W3aN3aN4

if object_id('rule_W3aN3aN4') is not null drop table rule_W3aN3aN4
select distinct a.new_id as new_id1, b.new_id as new_id2
into rule_W3aN3aN4
from evaluated_patterns as a
join evaluated_patterns as b on
	(a.pages_start=b.pages_start
	and a.pages_end=b.pages_end
	and a.volume=b.volume
	and a.issue=b.issue
	and a.d_year=b.d_year
	and a.d_month=b.d_month) --N3a
	and a.name=b.name --W3a
	and (a.count_of_numbers=b.count_of_numbers
	and a.sum_of_numbers=b.sum_of_numbers
	and a.count_of_numbers>6
	and b.count_of_numbers>6) --N4
where a.new_id < b.new_id
	and a.aetal is null
	and b.aetal is null
go

--SCORE PAIRS

if object_id('pairs_tmp') is not null drop table pairs_tmp
if object_id('publn_pairs_AB3x') is not null drop table publn_pairs_AB3x
go

--Score points
declare @score_N1 int = 9
declare @score_N2 int = 7
declare @score_N3a int = 6
declare @score_N3b int = 3
declare @score_N4 int = 1

declare @score_W1a int = 9
declare @score_W1b int = 8
declare @score_W2a int = 7
declare @score_W3a int = 6
declare @score_W2b int = 5
declare @score_W3b int = 4
declare @score_W4 int = 3
declare @score_W5 int = 2
declare @score_W6 int = 1

declare @bonus int = 4

--Neg rule vars
declare @threshold int = 13 --12 is the minimum a triple rule can score, needs 1 more point to be a valid duplicate. 9 for investigation, real: 13
declare @neg_pairs_pass_points int = 9 -- it gets added to the last used neg_pair_pass_points

select a.new_id1, a.new_id2, score = sum(a.score) 
into pairs_tmp
from 
(
	select * from publn_pairs_AB
	union all
	--select new_id1, new_id2, (-(@neg_pairs_pass_points-@threshold)) as score from rule_A
	--union all
	select new_id1, new_id2, (@bonus) as score from rule_N1W4W5a
	union all
	select new_id1, new_id2, (@bonus) as score from rule_N1W4W5b
	union all
	select new_id1, new_id2, (@bonus) as score from rule_N1W3bW4
	union all
	select new_id1, new_id2, (@bonus) as score from rule_N1W2bW5b
	union all
	select new_id1, new_id2, (@bonus) as score from rule_N2W3bW4
	union all
	--select new_id1, new_id2, (@bonus) as score from rule_N2W3bW5b
	--union all
	select new_id1, new_id2, (@bonus) as score from rule_W1bN3bW4
	union all
	select new_id1, new_id2, (@bonus) as score from rule_W2aN3bW4
	union all
	select new_id1, new_id2, (@bonus) as score from rule_W1aN3aN4
	union all
	select new_id1, new_id2, (@bonus) as score from rule_W1bN3aN4
	union all
	select new_id1, new_id2, (@bonus) as score from rule_W2aN3aN4
	union all
	select new_id1, new_id2, (@bonus) as score from rule_W3aN3aN4
) as a
group by a.new_id1, a.new_id2


--Prepare table for clustering algorithm

select *
into publn_pairs_AB3x
from pairs_tmp as a
where a.score>=@threshold
go

--Clean up

if object_id('pairs_tmp') is not null drop table pairs_tmp
go

--Inspect
select a.new_id1, d.npl_biblio, a.new_id2, e.npl_biblio, a.score
from publn_pairs_AB3x as a
join sample_glue	as b on a.new_id1 = b.new_id
join sample_glue	as c on a.new_id2 = c.new_id
join sample_table	as d on b.npl_publn_id = d.npl_publn_id
join sample_table	as e on c.npl_publn_id = e.npl_publn_id
order by a.score desc
go