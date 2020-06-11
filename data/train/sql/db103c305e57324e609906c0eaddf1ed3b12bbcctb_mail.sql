/*
1-jan-10,lau@ciysys.com
- This table keeps a copy of the email sent by the server. The application may 
  append the message into this table and then the schedule mail routing program
  will responsible to send the email.

*/

if not exists(
	select *
	from sys.objects
	where name = 'tb_mail'
)
begin

	CREATE TABLE tb_mail (
		row_id BIGINT NOT NULL,
		row_guid UNIQUEIDENTIFIER NOT NULL,
		send_to_email NVARCHAR(MAX) NULL,
		cc_to_email NVARCHAR(MAX) NULL,
		subject NVARCHAR(255) NULL,
		body_text NVARCHAR(MAX) NULL,
		attach_file NVARCHAR(MAX) NULL,
		created_on DATETIME NULL,
		sent_status_id INT NULL,
		sent_on DATETIME NULL,
		mail_type_id INT NULL,
		reply_to NVARCHAR(MAX) NULL
	);

end
go

if not exists(
	select *
	from sys.objects
	where name = 'PK_tb_mail'
)
begin

	ALTER TABLE tb_mail ADD CONSTRAINT PK_tb_mail PRIMARY KEY (row_id);

end
go

if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_mail_2'
)
begin

	CREATE INDEX IX_tb_mail_2 ON tb_mail (sent_status_id);

end
go

if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_mail_3'
)
begin

	CREATE INDEX IX_tb_mail_3 ON tb_mail (row_guid);

end
go

if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_mail_4'
)
begin

	CREATE INDEX IX_tb_mail_4 ON tb_mail (mail_type_id);

end
go
