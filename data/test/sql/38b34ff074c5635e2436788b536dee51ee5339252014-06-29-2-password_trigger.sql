CREATE EXTENSION plpythonu;

CREATE OR REPLACE FUNCTION password_hash()
  RETURNS trigger AS
$BODY$
    import hashlib

    new_pass = hashlib.sha256(TD['new']['password']).hexdigest()
    if TD['event'] == 'UPDATE':
        old_pass = hashlib.sha256(TD['old']['password']).hexdigest()
        if old_pass != new_pass:
            print(new_pass)
            TD['new']['password'] = new_pass
    else:
    
        TD['new']['password'] = new_pass

    return "MODIFY"
$BODY$
  LANGUAGE plpythonu VOLATILE
  COST 100;
ALTER FUNCTION password_hash()
  OWNER TO "civ-user";

  
CREATE TRIGGER hashpassword
  BEFORE INSERT OR UPDATE
  ON users
  FOR EACH ROW
  EXECUTE PROCEDURE password_hash();