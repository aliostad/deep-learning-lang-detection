CREATE TABLE usuario_log(
	id INT
	,accion VARCHAR(25)
	,id_usuario INT
	,old_ci INT
	,new_ci INT
	,old_nombre VARCHAR(50)
	,new_nombre VARCHAR(50)
	,old_ap_paterno VARCHAR(30)
	,new_ap_paterno VARCHAR(30)
	,fecha TIMESTAMP 
);

CREATE TRIGGER nuevo_usuario AFTER INSERT ON usuario
    FOR EACH ROW
    INSERT usuario_log(accion,id_usuario,new_ci,new_nombre,new_ap_paterno,fecha) VALUES('INSERT',NEW.id_usuario,NEW.ci,NEW.nombre,NEW.ap_paterno,NOW())
;
INSERT INTO usuario(ci,nombre,ap_paterno,fecha_nacimiento,email) 
       VALUES(147,'wilmer','valencia','01-01-2000','valencia@hotmail.com');


DROP TRIGGER eliminar_usuario;       
CREATE TRIGGER eliminar_usuario BEFORE DELETE ON usuario
    FOR EACH ROW
    INSERT usuario_log(accion,id_usuario,old_ci,old_nombre,old_ap_paterno,fecha) VALUES('DELETE',OLD.id_usuario,OLD.ci,OLD.nombre,OLD.ap_paterno,NOW())
;

DELETE FROM usuario WHERE id_usuario=2; 
       
       