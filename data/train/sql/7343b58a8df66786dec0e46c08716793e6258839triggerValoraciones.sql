-- Trigger encargado de la gestión de la valoración media de cada una de las películas
-- de la colección pública.

CREATE OR REPLACE TRIGGER valoracion_media_insertar
BEFORE INSERT OR UPDATE OR DELETE ON Vista
FOR EACH ROW
DECLARE
	cuenta NUMBER(10,5);
	valoracion_pelicula NUMBER(10,5);
BEGIN
	if inserting then
		SELECT numVistas INTO cuenta FROM Pelicula WHERE (id=:new.pelicula);
		SELECT puntuacion INTO valoracion_pelicula FROM Pelicula WHERE (id=:new.pelicula); 
		UPDATE Pelicula SET valoracion=((valoracion_pelicula+:new.valoracion)/(cuenta + 1)) WHERE (id=:new.pelicula);
		UPDATE Pelicula SET numVistas=cuenta+1 where (id=:new.pelicula);
		UPDATE Pelicula SET puntuacion=(valoracion_pelicula+:new.valoracion) WHERE (id=:new.pelicula);
	elsif updating then
		SELECT puntuacion INTO valoracion_pelicula FROM Pelicula WHERE (id=:new.pelicula); 
		UPDATE Pelicula SET puntuacion=(valoracion_pelicula-:old.valoracion) WHERE (id=:new.pelicula);
		SELECT puntuacion INTO valoracion_pelicula FROM Pelicula WHERE (id=:new.pelicula);
		UPDATE Pelicula SET puntuacion=(valoracion_pelicula+:new.valoracion) WHERE (id=:new.pelicula);
		SELECT numVistas INTO cuenta FROM Pelicula WHERE (id=:new.pelicula);
		SELECT puntuacion INTO valoracion_pelicula FROM Pelicula WHERE (id=:new.pelicula);
		UPDATE Pelicula SET valoracion=(valoracion_pelicula/cuenta) WHERE (id=:new.pelicula);
	else
		SELECT numVistas INTO cuenta FROM Pelicula WHERE (id=:old.pelicula);
		SELECT puntuacion INTO valoracion_pelicula FROM Pelicula WHERE (id=:old.pelicula);
		UPDATE Pelicula SET valoracion=((valoracion_pelicula-:old.valoracion)/(cuenta-1)) WHERE (id=:old.pelicula);
		UPDATE Pelicula SET numVistas=(cuenta-1) where 
(id=:old.pelicula);
		UPDATE Pelicula SET puntuacion=(valoracion_pelicula-:old.valoracion) WHERE (id=:old.pelicula);
	end if;
END;
/
