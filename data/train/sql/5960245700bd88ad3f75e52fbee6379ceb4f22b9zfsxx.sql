-- drop table dict;
create table dict (
	up integer,
	n integer,
	term text,
	dsc text
);
create unique index dict_up_n on dict(up,n);
create index dict_up on dict(up);
create index dict_n on dict(n);
create index dict_term on dict(term);

-- 0 dictionary: type of operation
insert into dict values(0, 0, 'sequential_read', 'sequential read');
insert into dict values(0, 1, 'sequential_write', 'sequential write');
insert into dict values(0, 2, 'random_read', 'random read');
insert into dict values(0, 3, 'random_read_write', 'random 50% read and 50% write');
insert into dict values(0, 4, 'random_write', 'random write');

-- 1 dictionary: type of dedup
insert into dict values(1, 0, 'off', 'off');
insert into dict values(1, 1, 'on', 'on');
insert into dict values(1, 2, 'verify', 'verify');
insert into dict values(1, 3, 'sha256', 'sha256');
insert into dict values(1, 4, 'sha256_verify', 'sha256,verify');

-- 2 dictionary: milestone
insert into dict values(2, 0, '4.0m23', 'NexentaStor 4.0 Milestone 22a');
insert into dict values(2, 1, '4.0m23', 'NexentaStor 4.0 Milestone 22');

-- 3 dictionary: description for data
insert into dict values(3, 0, 'operation_type', 'type of operation');
insert into dict values(3, 1, 'dedup_type', 'type of deduplication');
insert into dict values(3, 2, 'rate', 'IOPS');
insert into dict values(3, 3, 'resp', 'duration of the read/write request');
insert into dict values(3, 4, 'total_mb', 'data transferred');
insert into dict values(3, 5, 'read_rate', 'read IOPS');
insert into dict values(3, 6, 'read_resp', 'duration of the read request');
insert into dict values(3, 7, 'write_rate', 'write IOPS');
insert into dict values(3, 8, 'write_resp', 'duration of the write request');
insert into dict values(3, 9, 'read_mb', 'data read');
insert into dict values(3, 10, 'write_mb', 'data write');
insert into dict values(3, 11, 'cpu_used', 'CPU common utilization');
insert into dict values(3, 12, 'cpu_user', 'CPU user utilization');
insert into dict values(3, 13, 'cpu_kernel', 'CPU kernel utilization');
insert into dict values(3, 14, 'cpu_wait', 'CPU wait');
insert into dict values(3, 15, 'cpu_idle', 'CPU idle');

-- 4 dictionary: units for data
insert into dict values(4, 2, 'rate', 'IOPS');
insert into dict values(4, 3, 'resp', 'msec');
insert into dict values(4, 4, 'total_mb', 'MB/sec');
insert into dict values(4, 5, 'read_rate', 'IOPS');
insert into dict values(4, 6, 'read_resp', 'msec');
insert into dict values(4, 7, 'write_rate', 'IOPS');
insert into dict values(4, 8, 'write_resp', 'msec');
insert into dict values(4, 9, 'cpu_used', '%');
insert into dict values(4, 10, 'cpu_user', '%');
insert into dict values(4, 11, 'cpu_kernel', '%');
insert into dict values(4, 12, 'cpu_wait', '%');
insert into dict values(4, 13, 'cpu_idle', '%');

-- drop table data;
create table data (
	milestone integer,
	block_size integer,
	operation_type integer,
	dedup_type integer,
	dedup_ratio real,
	rate real,
	resp real,
	total_mb real,
	read_rate real,
	read_resp real,
	write_rate real,
	write_resp real,
	read_mb real,
	write_mb real,
	cpu_used real,
	cpu_user real,
	cpu_kernel real,
	cpu_wait real,
	cpu_idle real
);
create index data_milestone on data(milestone);
create index data_block_size on data(block_size);
create index data_operation_type on data(operation_type);
create index data_dedup_type on data(dedup_type);
