create table dbo.UserReadFeedItem (
  Id int identity(1, 1) not null,
  UserAccountId int not null,
  FeedItemId int not null,
  DateCreated datetime2 not null,
  constraint PK_UserReadFeedItem primary key clustered (
    Id asc
  ),
  constraint FK_UserReadFeedItem_UserAccount foreign key (UserAccountId) references UserAccount (Id),
  constraint FK_UserReadFeedItem_FeedItem foreign key (FeedItemId) references FeedItem (Id),
)
go

create unique nonclustered index IX_UserReadFeedItem_UserAccountId_FeedItemId on dbo.UserReadFeedItem
(
  UserAccountId asc,
  FeedItemId asc
)
go
