create table blocked_user (
	blockedUserId LONG not null primary key,
	ownerId LONG,
	userId LONG,
	blockedDate DATE null
);

create table deleted_message (
	deletedMessageId LONG not null primary key,
	messageId LONG,
	ownerId LONG,
	deletedDate DATE null
);

create table private_message (
	messageId LONG not null primary key,
	subject VARCHAR(75) null,
	body TEXT null,
	parentMessageId LONG,
	ownerId LONG,
	ownerName VARCHAR(75) null,
	postedDate DATE null,
	recepients VARCHAR(75) null
);

create table read_message (
	readMessageId LONG not null primary key,
	messageId LONG,
	readDate DATE null
);