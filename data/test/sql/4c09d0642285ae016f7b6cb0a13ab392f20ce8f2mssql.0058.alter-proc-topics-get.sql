Alter VIEW [dbo].[TopicsComplete]   
AS  
SELECT  
	T.TopicId  
	,T.TopicTitle  
	,T.TopicShortName  
	,T.TopicDescription  
	,T.TopicCreationDate  
	,T.TopicViews  
	,T.TopicReplies  
	,T.UserId  
	,T.TopicTags  
	,T.TopicIsClose  
	,T.TopicOrder  
	,T.LastMessageId  
	,U.UserName
	,U.UserPhoto
	,U.UserRegistrationDate
	,U.UserSignature
	,U.UserGroupId
	,F.ForumId  
	,F.ForumName  
	,F.ForumShortName
	,CASE   
	WHEN ISNULL(T.ReadAccessGroupId, -1) >= ISNULL(F.ReadAccessGroupId, -1) THEN T.ReadAccessGroupId  
	ELSE F.ReadAccessGroupId END AS ReadAccessGroupId  
	,CASE   
	WHEN T.PostAccessGroupId >= ISNULL(F.ReadAccessGroupId,-1) THEN T.PostAccessGroupId -- Do not inherit post access  
	ELSE F.ReadAccessGroupId END AS PostAccessGroupId -- use the parent read access, if greater  
FROM  
	Topics T  
	INNER JOIN Users U ON U.UserId = T.UserId  
	INNER JOIN Forums F ON F.ForumId = T.ForumId  
WHERE  
	T.Active = 1  
	AND  
	F.Active = 1
Go

Alter PROCEDURE [dbo].[SPTopicsGet]
	@TopicId int=1
AS
SELECT
	T.TopicId  
	,T.TopicTitle  
	,T.TopicShortName  
	,T.TopicDescription  
	,T.TopicCreationDate  
	,T.TopicViews  
	,T.TopicReplies  
	,T.UserId  
	,T.TopicTags  
	,T.TopicIsClose  
	,T.TopicOrder  
	,T.LastMessageId  
	,T.UserName
	,T.UserPhoto
	,T.UserRegistrationDate
	,T.UserSignature
	,T.UserGroupId
	,UG.UserGroupName 
	,T.ForumId  
	,T.ForumName  
	,T.ForumShortName  
	,T.ReadAccessGroupId  
	,T.PostAccessGroupId  
FROM 
	TopicsComplete T
		INNER JOIN UsersGroups UG ON UG.UserGroupId = T.UserGroupId    
WHERE
	T.TopicId = @TopicId
GO