CREATE OR REPLACE 
PROCEDURE agregarPersona(
    newRut varchar,
    newNombre varchar,
    newEmail varchar,
    newPassword varchar,
    newTelefono int,
    newTelefono_2 int,
    newDireccion varchar,
    newAdmin boolean,
    newFecha_nacimiento timestamp,
    newFecha_ingreso_hostal timestamp
    )
IS
BEGIN
  INSERT INTO persona 
    (   rut,
        nombre, 
        email,
        password,
        telefono,
        telefono_2,
        direccion,
        admin,
        fecha_nacimiento,
        fecha_ingreso_hostal)
    VALUES(newRut,
        newNombre, 
        newEmail,
        newPassword,
        newTelefono,
        newTelefono_2,
        newDireccion,
        NewAdmin,
        newFecha_nacimiento,
        newFecha_ingreso_hostal);

END agregarPersona; 