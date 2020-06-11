DROP TRIGGER IF EXISTS ventas_compute_fields_insert_trigger;
CREATE TRIGGER ventas_compute_fields_insert_trigger
AFTER INSERT ON ventas
FOR EACH ROW BEGIN
	UPDATE ventas SET
	       total = NEW.precio * NEW.volumen
	WHERE gid = NEW.gid;

	-- Con esto relanzamos el update trigger de balances
	UPDATE balances SET
	       venta_total = (SELECT sum(ventas.total) FROM ventas WHERE ventas.cod_balance = NEW.cod_balance)
	WHERE cod_balance = NEW.cod_balance;

	-- Con esto relanzamos el update trigger de compradores
	UPDATE compradores SET 
	       compra_total = (SELECT sum(ventas.total) FROM ventas WHERE ventas.cod_comprador = NEW.cod_comprador)
	WHERE cod_comprador = NEW.cod_comprador;


END;

DROP TRIGGER IF EXISTS ventas_compute_fields_update_trigger;
CREATE TRIGGER ventas_compute_fields_update_trigger
AFTER UPDATE ON ventas
FOR EACH ROW BEGIN
	UPDATE ventas SET
	       total = NEW.precio * NEW.volumen
	WHERE gid = NEW.gid;

	-- Con esto relanzamos el update trigger de balances
	UPDATE balances SET
	       venta_total = (SELECT sum(ventas.total) FROM ventas WHERE ventas.cod_balance = NEW.cod_balance)
	WHERE cod_balance = NEW.cod_balance;

	-- Con esto relanzamos el update trigger de compradores
	UPDATE compradores SET 
	       compra_total = (SELECT sum(ventas.total) FROM ventas WHERE ventas.cod_comprador = NEW.cod_comprador)
	WHERE cod_comprador = NEW.cod_comprador;

END;