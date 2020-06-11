delimiter $$
drop trigger if exists adm_seq_air_trg $$
drop trigger if exists adm_seq_rep_air_trg $$
CREATE TRIGGER adm_seq_rep_air_trg after insert
    ON adm_sequence_rep FOR EACH ROW
BEGIN

       insert into adm_sequence values (new.pkey,new.name,new.init_number,new.last_number,
            new.max_number,new.increment_by,new.cycle_flag);

END$$

drop trigger if exists adm_seq_adr_trg $$
drop trigger if exists adm_seq_rep_adr_trg $$
CREATE TRIGGER adm_seq_rep_adr_trg after delete
    ON adm_sequence_rep FOR EACH ROW
BEGIN

       delete from adm_sequence where pkey=old.pkey;

END$$
delimiter ;