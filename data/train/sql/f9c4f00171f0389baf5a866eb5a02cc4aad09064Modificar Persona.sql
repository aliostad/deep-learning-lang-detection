CREATE OR REPLACE 
PROCEDURE modificarPersona(
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
    (   newRut,
        newNombre, 
        newEmail,
        newPassword,
        newTelefono,
        newTelefono_2,
        direccion = newDireccion,
        newAdmin = admin,
        newFecha_nacimiento = fecha_nacimiento,
        newFecha_ingreso_hostal = fecha_ingreso_hostal
  WHERE rut = updateRut;

END modificarPersona; 