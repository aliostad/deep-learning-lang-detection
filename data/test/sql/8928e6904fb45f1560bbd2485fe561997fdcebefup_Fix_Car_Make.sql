use QSM;

IF OBJECT_ID(N'up_Fix_Car_Make') IS NOT NULL
	DROP PROC up_Fix_Car_Make;
GO

CREATE PROC up_Fix_Car_Make
AS

DECLARE @MakeModel TABLE
(
	Make	varchar(20),
	Model	varchar(30),
	Cnt		int
);

INSERT @MakeModel (Make, Model, Cnt)
SELECT Make, Model, count(*)
FROM CarData.Car
WHERE Make = '' and Model <> ''
  and Model like '[A-Z]%'
GROUP BY Make, Model;

/*
select * from @MakeModel
where Cnt > 10
order by Model, Cnt desc
;
*/

DECLARE @Make  varchar(20);
DECLARE @Model varchar(30);

DECLARE m_cursor CURSOR FOR SELECT Model FROM @MakeModel;

DECLARE @f table
(
	Make		varchar(20),
	Model		varchar(30),
	Cnt			int,
	Rate		numeric(3,2)
-- 	MakeMatch	char(1)
);

OPEN m_cursor;
FETCH NEXT FROM m_cursor INTO @Model;

declare @i smallint = 0;
declare @total float = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
	delete @f;

	insert @f (Make, Model, Cnt)
	select Make, Model, count(*) Cnt
	from CarData.Car
	where Model = @Model
	  and Make <> ''
	group by Make, Model;

	select @total = sum(Cnt) FROM @f;

	update @f set Rate = cast((cast(Cnt as float) / @Total) as numeric(3,2));

	SET @Make = (select TOP 1 Make FROM @f ORDER BY Rate DESC);

-- 	update @f set MakeMatch = 'Y' where Make = @Make;

	select @Make, @Model;

	update CarData.Car set Make = @Make
	where Model = @Model
	  and Make <> @Make;

/*
	SET @i += 1;
	if (@i > 2)
		BREAK;
*/
--	select * from @f;

	FETCH NEXT FROM m_cursor INTO @Model;
END

CLOSE m_cursor;
DEALLOCATE m_cursor;


/*
update CarData.Car set Make = 'CHEVROLET'
where Model = 'ALTIMA'
  and Make <> 'CHEVROLET'
*/
GO

exec up_Fix_Car_Make;

/*
select * from CarData.ModelErr
where Make = 'Toyota'

update CarData.Car set Make = e.Make, Model = e.Model
from CarData.Car c, CarData.ModelErr e
where c.Make = ''
  and c.Model = e.ModelErr


select c.Make, c.Model, e.Make, e.Model, count(*)
from CarData.Car c, CarData.ModelErr e
where c.Make = ''
  and c.Model = e.ModelErr
group by c.Make, c.Model, e.Make, e.Model

*/

