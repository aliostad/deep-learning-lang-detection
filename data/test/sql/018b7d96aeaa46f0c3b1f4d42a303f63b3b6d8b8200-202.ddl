DROP TRIGGER k_tr_ins_address ON k_addresses
GO;

DROP FUNCTION k_sp_ins_address()
GO;

DROP TRIGGER k_tr_upd_address ON k_addresses
GO;

DROP FUNCTION k_tr_upd_address()
GO;

CREATE FUNCTION k_sp_ins_address() RETURNS OPAQUE AS '
DECLARE
  AddrId CHAR(32);

BEGIN
  IF NEW.bo_active=1 THEN
    SELECT gu_address INTO AddrId FROM k_member_address WHERE gu_address=NEW.gu_address;

    IF NOT FOUND THEN
      INSERT INTO k_member_address (gu_address,ix_address,gu_workarea,dt_created,dt_modified,gu_writer,nm_legal,tp_location,tp_street,nm_street,nu_street,tx_addr1,tx_addr2,full_addr,id_country,nm_country,id_state,nm_state,mn_city,zipcode,work_phone,direct_phone,home_phone,mov_phone,fax_phone,other_phone,po_box,tx_email,url_addr,contact_person,tx_salutation,tx_remarks) VALUES (NEW.gu_address,NEW.ix_address,NEW.gu_workarea,NEW.dt_created,NEW.dt_modified,NEW.gu_user,NEW.nm_company,NEW.tp_location,NEW.tp_street,NEW.nm_street,NEW.nu_street,NEW.tx_addr1,NEW.tx_addr2,COALESCE(NEW.tx_addr1,'')||CHR(10)||COALESCE(NEW.tx_addr2,''),NEW.id_country,NEW.nm_country,NEW.id_state,NEW.nm_state,NEW.mn_city,NEW.zipcode,NEW.work_phone,NEW.direct_phone,NEW.home_phone,NEW.mov_phone,NEW.fax_phone,NEW.other_phone,NEW.po_box,NEW.tx_email,NEW.url_addr,NEW.contact_person,NEW.tx_salutation,NEW.tx_remarks);
    END IF;
  END IF;

  RETURN NEW;
END;
' LANGUAGE 'plpgsql';
GO;

CREATE TRIGGER k_tr_ins_address AFTER INSERT ON k_addresses FOR EACH ROW EXECUTE PROCEDURE k_sp_ins_address()
GO;

CREATE FUNCTION k_sp_upd_address() RETURNS OPAQUE AS '
DECLARE
  AddrId CHAR(32);

BEGIN
  IF NEW.bo_active=1 THEN
    SELECT gu_address INTO AddrId FROM k_member_address WHERE gu_address=NEW.gu_address;

    IF NOT FOUND THEN
      INSERT INTO k_member_address (gu_address,ix_address,gu_workarea,dt_created,dt_modified,gu_writer,nm_legal,tp_location,tp_street,nm_street,nu_street,tx_addr1,tx_addr2,full_addr,id_country,nm_country,id_state,nm_state,mn_city,zipcode,work_phone,direct_phone,home_phone,mov_phone,fax_phone,other_phone,po_box,tx_email,url_addr,contact_person,tx_salutation,tx_remarks) VALUES (NEW.gu_address,NEW.ix_address,NEW.gu_workarea,NEW.dt_created,NEW.dt_modified,NEW.gu_user,NEW.nm_company,NEW.tp_location,NEW.tp_street,NEW.nm_street,NEW.nu_street,NEW.tx_addr1,NEW.tx_addr2,COALESCE(NEW.tx_addr1,'')||CHR(10)||COALESCE(NEW.tx_addr2,''),NEW.id_country,NEW.nm_country,NEW.id_state,NEW.nm_state,NEW.mn_city,NEW.zipcode,NEW.work_phone,NEW.direct_phone,NEW.home_phone,NEW.mov_phone,NEW.fax_phone,NEW.other_phone,NEW.po_box,NEW.tx_email,NEW.url_addr,NEW.contact_person,NEW.tx_salutation,NEW.tx_remarks);
    ELSE
      UPDATE k_member_address SET ix_address=NEW.ix_address,gu_workarea=NEW.gu_workarea,dt_created=NEW.dt_created,dt_modified=NEW.dt_modified,gu_writer=NEW.gu_user,nm_legal=NEW.nm_company,tp_location=NEW.tp_location,tp_street=NEW.tp_street,nm_street=NEW.nm_street,nu_street=NEW.nu_street,tx_addr1=NEW.tx_addr1,tx_addr2=NEW.tx_addr2,full_addr=COALESCE(NEW.tx_addr1,'')||CHR(10)||COALESCE(NEW.tx_addr2,''),id_country=NEW.id_country,nm_country=NEW.nm_country,id_state=NEW.id_state,nm_state=NEW.nm_state,mn_city=NEW.mn_city,zipcode=NEW.zipcode,work_phone=NEW.work_phone,direct_phone=NEW.direct_phone,home_phone=NEW.home_phone,mov_phone=NEW.mov_phone,fax_phone=NEW.fax_phone,other_phone=NEW.other_phone,po_box=NEW.po_box,tx_email=NEW.tx_email,url_addr=NEW.url_addr,contact_person=NEW.contact_person,tx_salutation=NEW.tx_salutation,tx_remarks=NEW.tx_remarks WHERE gu_address=NEW.gu_address;
    END IF;
  ELSE
    DELETE FROM k_member_address WHERE gu_address=NEW.gu_address;
  END IF;

  RETURN NEW;
END;
' LANGUAGE 'plpgsql';
GO;

CREATE TRIGGER k_tr_upd_address AFTER UPDATE ON k_addresses FOR EACH ROW EXECUTE PROCEDURE k_sp_upd_address()
GO;

UPDATE k_version SET vs_stamp='2.0.2'
GO;
