--DROP TRIGGER insert_property;
CREATE TRIGGER IF NOT EXISTS insert_property
INSTEAD OF INSERT ON molecule_method_property_denorm
FOR EACH ROW BEGIN
  INSERT OR IGNORE INTO property (name, description, format)
  VALUES (NEW.name,
          NEW.description,
          NEW.format);
  INSERT OR REPLACE INTO molecule_method_property (inchikey,
                                                   method_path_id,
                                                   property_id,
                                                   units,
                                                   result)
  SELECT NEW.inchikey,
         NEW.method_path_id,
         property.property_id,
         NEW.units,
         NEW.result
  FROM property
  WHERE property.name = NEW.name
    AND property.description = NEW.description
    AND property.format = NEW.format;
END;
