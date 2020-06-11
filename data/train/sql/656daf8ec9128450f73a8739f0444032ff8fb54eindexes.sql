create index IX_52A74255 on new_perfect_journal_Article (articleStatus);
create index IX_FEE8DDD9 on new_perfect_journal_Article (isArticlePublished);
create index IX_1C755BBD on new_perfect_journal_Article (userId);
create index IX_992C29D1 on new_perfect_journal_Article (uuid_);
create unique index IX_CDECC5F9 on new_perfect_journal_Article (uuid_, groupId);

create index IX_1F760ACA on new_perfect_journal_Review (articleId);
create index IX_6CEF40DD on new_perfect_journal_Review (uuid_);
create unique index IX_9224DC6D on new_perfect_journal_Review (uuid_, groupId);