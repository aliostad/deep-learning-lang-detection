-- Usuarios
-- begin
CREATE TRIGGER agregar_usuario_docente
AFTER INSERT ON docente
FOR EACH ROW
INSERT INTO users(email,password,tipoUsuario,nroId,estado,created_at)
values (NEW.email,NEW.password,'Docente',NEW.id,NEW.estado,NOW());

CREATE TRIGGER agregar_usuario_personal
AFTER INSERT ON personal
FOR EACH ROW
INSERT INTO users(email,password,tipoUsuario,nroId,estado,created_at)
values (NEW.email,NEW.password,'Personal',NEW.id,NEW.estado,NOW());

CREATE TRIGGER agregar_usuario_alumno
AFTER INSERT ON alumno
FOR EACH ROW
INSERT INTO users(email,password,tipoUsuario,nroId,estado,created_at)
values (NEW.email,NEW.password,'Alumno',NEW.id,NEW.estado,NOW());
-- end

-- Nota Matricula Curso de Carrera tecnica
-- begin
CREATE TRIGGER agregar_notas_ct
AFTER INSERT ON matricula_ct
FOR EACH ROW
INSERT INTO nota_ct(codMatricula_ct,notaa,notab,notac)
values (NEW.id,0,0,0);
-- end
-- Nota Matricula Curso Libre
-- begin
CREATE TRIGGER agregar_notas_cl
AFTER INSERT ON matricula_cl
FOR EACH ROW
INSERT INTO nota_cl(codMatricula_cl,nota)
values (NEW.id,0);
-- end