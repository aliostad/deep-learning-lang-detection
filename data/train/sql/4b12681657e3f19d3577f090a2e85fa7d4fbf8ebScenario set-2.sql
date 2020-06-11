/*1.Write a query to get all the goal for a given gradeId  */
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select kg.GoalId,kg.Goal_Number,kg.Goal from kg_goals as kg
		join grades g
			on kg.GradeId=g.GradeId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/*2.Write a query to get all the goal details for a given AssignmentId*/
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select * from kg_goals as kg
		join assignment_assigned aa
			on kg.GoalId=aa.GoalId
		join student_assignments sa
			on aa.AssignmentId= sa.AssignmentId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/*3.Write a query to get all the goal details for a given StudentProfileId*/
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select  * from kg_goals as kg
		join student_assignments sa
			on kg.GoalId=sa.GoalId
		 join student_profiles sp
			on sa.ProfileId = sp.ProfileId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
	
/*4.Write a query to get all the  skill details for a given GoalId*/
	select * from kg_skills as ks
		join kg_goalskills  kgs
			on ks.SkillId = kgs.SkillId
		join kg_goals kg
			on kgs.GoalId = kg.GoalId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
	
/*5.Write a query to get all the  parent Goal details for a given GoalId*/
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select  * from kg_goals as kg
		join kg_goal_hierarchy kgh
			on kg.GoalId = kgh.PreReq_GoalId;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/*6.Write a query to get all Goal details which have not any parent Goal*/
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select  * from kg_goals as kg
		join kg_goal_hierarchy kgh
			on kg.GoalId = kgh.GoalId
	where kgh.PreReq_GoalId is null; 
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

