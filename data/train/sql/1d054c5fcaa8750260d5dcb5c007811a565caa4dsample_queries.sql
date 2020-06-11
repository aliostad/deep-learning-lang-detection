/*1.Write a query to get all the users whole belong to a Role Teacher for a given schoolId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select distinct tp.ProfileId ,up.LastName  from teacher_profiles  as tp 
join user_profiles up
	on tp.ProfileId=up.ProfileId
join user_profiles_school ups
	on  tp.ProfileId = ups.ProfileId
join schools scls
	on ups.SchoolId=scls.SchoolId
where tp.active='on' ;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;


/*2.Write a query to get all Students and teachers for a given schoolId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select up.FirstName,up.ProfileId from user_profiles as up
join user_profiles_school ups
	on up.ProfileId=ups.ProfileId
join schools scls
	on ups.SchoolId=scls.SchoolId
where ((teacher_profiles.active='on') AND (student_profiles.Active='on'));
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/*3.Write a query to get all classes for a given teacherId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select distinct cls.ClassName from class as cls
join class_teachers ct
	on cls.ClassId=ct.ClassId
join user_profiles_school ups
	on ct.TeacherId=ups.ProfileId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* 4.Write a query to get all the students for a given groupId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select distinct sg.ProfileId,up.FirstName from student_group as sg
join user_profiles up
	on sg.profileId=up.ProfileId
join waggle_latest.group grp
	on sg.GroupId=grp.GroupId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* 5.Write a query to get all the assignments assigned to a student for a given studentId  */

/* for students*/
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select distinct a1.assignmentName,sa.ProfileId from assignments as a1
join assignment_assigned aa
	on a1.AssignmentId=aa.AssignmentId
join student_assignments sa
	on aa.AssignedToId=sa.ProfileId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* for class */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select distinct a1.assignmentName,aa.AssignedToId from assignments as a1
join assignment_assigned aa
	on a1.AssignmentId=aa.AssignmentId
join student_assignments sa
	on aa.AssignedToId=sa.ClassId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* 6.Write a query to get all the students who don't have any assignments  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
select ProfileId from student_profiles 
 where ProfileId not in (select ProfileId from student_assignments);
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;