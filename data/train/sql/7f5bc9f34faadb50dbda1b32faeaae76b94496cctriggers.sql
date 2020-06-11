/* Criando triggers de replicação 
 * As triggers serão criadas na base de dados empresa */
use empresa;

/* Modificamos o delimitardor para conseguir escrever corretamente as triggers */
DELIMITER $$

/* FUNCIONARIOS */
CREATE TRIGGER funcionario_insert AFTER INSERT
ON empresa.funcionario
FOR EACH ROW
BEGIN
INSERT INTO empresa_replica.funcionario(pnome, minicial, unome, cpf, datanasc, endereco, sexo, salario, supercpf, dno) VALUES (new.pnome, new.minicial, new.unome, new.cpf, new.datanasc, new.endereco, new.sexo, new.salario, new.supercpf, new.dno);
END$$

CREATE TRIGGER funcionario_update AFTER UPDATE
ON empresa.funcionario
FOR EACH ROW
BEGIN
UPDATE empresa_replica.funcionario 
SET pnome = new.pnome, minicial = new.minicial, unome = new.unome, cpf = new.cpf, datanasc = new.datanasc, endereco = new.endereco, sexo = new.sexo, salario = new.salario, supercpf = new.supercpf, dno = new.dno
WHERE cpf = old.cpf;
END$$

CREATE TRIGGER funcionario_delete AFTER DELETE
ON empresa.funcionario
FOR EACH ROW
BEGIN
DELETE FROM empresa_replica.funcionario
WHERE cpf = old.cpf;
END$$

/* DEPARTAMENTO */
CREATE TRIGGER departamento_insert AFTER INSERT
ON empresa.departamento
FOR EACH ROW
BEGIN
INSERT INTO empresa_replica.departamento(dnome, dnumero, gercpf, gerdatainicio) values (new.dnome, new.dnumero, new.gercpf, new.gerdatainicio);
END$$

CREATE TRIGGER departamento_update AFTER UPDATE
ON empresa.departamento
FOR EACH ROW
BEGIN
UPDATE empresa_replica.departamento 
SET dnome = new.dnome, dnumero = new.dnumero, gercpf = new.gercpf, gerdatainicio = new.gerdatainicio
WHERE dnumero = old.dnumero;
END$$

CREATE TRIGGER departamento_delete AFTER DELETE
ON empresa.departamento
FOR EACH ROW
BEGIN
DELETE FROM empresa_replica.departamento
WHERE dnumero = old.dnumero;
END$$

/* DEPARTAMENTO LOCALIZACOES */
CREATE TRIGGER dept_localizacoes_insert AFTER INSERT
ON empresa.depto_localizacoes
FOR EACH ROW
BEGIN
INSERT INTO empresa_replica.depto_localizacoes(dnumero, dlocalizacao) values (new.dnumero, new.dlocalizacao);
END$$

CREATE TRIGGER depto_localizacoes_update AFTER UPDATE
ON empresa.depto_localizacoes
FOR EACH ROW
BEGIN
UPDATE empresa_replica.depto_localizacoes 
SET dnumero = new.dnumero, dlocalizacao = new.dlocalizacao
WHERE dnumero = old.dnumero AND dlocalizacao = old.dlocalizacao;
END$$

CREATE TRIGGER depto_localizacoes_delete AFTER DELETE
ON empresa.depto_localizacoes
FOR EACH ROW
BEGIN
DELETE FROM empresa_replica.depto_localizacoes
WHERE dnumero = old.dnumero AND dlocalizacao = old.dlocalizacao;
END$$

/* PROJETO */
CREATE TRIGGER projeto_insert AFTER INSERT
ON empresa.projeto
FOR EACH ROW
BEGIN
INSERT INTO empresa_replica.projeto (pjnome, pnumero, plocalizacao, dnum) values (new.pjnome, new.pnumero, new.plocalizacao, new.dnum);
END$$

CREATE TRIGGER projeto_update AFTER UPDATE
ON empresa.projeto
FOR EACH ROW
BEGIN
UPDATE empresa_replica.projeto 
SET pjnome = new.pjnome, pnumero = new.pnumero, plocalizacao = new.plocalizacao, dnum = new.dnum
WHERE pnumero = old.pnumero;
END$$

CREATE TRIGGER projeto_delete AFTER DELETE
ON empresa.projeto
FOR EACH ROW
BEGIN
DELETE FROM empresa_replica.projeto
WHERE pnumero = old.pnumero;
END$$

/* TRABALHA EM */
CREATE TRIGGER trabalha_em_insert AFTER INSERT
ON empresa.trabalha_em
FOR EACH ROW
BEGIN
INSERT INTO empresa_replica.trabalha_em (ecpf, pno, horas) values (new.ecpf, new.pno, new.horas);
END$$

CREATE TRIGGER trabalha_em_update AFTER UPDATE
ON empresa.trabalha_em
FOR EACH ROW
BEGIN
UPDATE empresa_replica.trabalha_em 
SET ecpf = new.ecpf, pno = new.pno, horas = new.horas
WHERE ecpf = old.ecpf and pno = old.pno;
END$$

CREATE TRIGGER trabalha_em_delete AFTER DELETE
ON empresa.trabalha_em
FOR EACH ROW
BEGIN
DELETE FROM empresa_replica.trabalha_em
WHERE ecpf = old.ecpf and pno = old.pno;
END$$


/* DEPENDENTE */
CREATE TRIGGER dependente_insert AFTER INSERT
ON empresa.dependente
FOR EACH ROW
BEGIN
INSERT INTO empresa_replica.dependente (ecpf, nome_dependente, sexo, datanasc, parentesco) values (new.ecpf, new.nome_dependente, new.sexo, new.datanasc, new.parentesco);
END$$

CREATE TRIGGER dependente_update AFTER UPDATE
ON empresa.dependente
FOR EACH ROW
BEGIN
UPDATE empresa_replica.dependente 
SET ecpf = new.ecpf, nome_dependente = new.nome_dependente, sexo = new.sexo, datanasc = new.datanasc, parentesco = new.parentesco
WHERE ecpf = old.ecpf and nome_dependente = old.nome_dependente;
END$$

CREATE TRIGGER dependente_delete AFTER DELETE
ON empresa.dependente
FOR EACH ROW
BEGIN
DELETE FROM empresa_replica.dependente
WHERE ecpf = old.ecpf and nome_dependente = old.nome_dependente;
END$$

/* redefinimos o identificador para ficar tudo certo */
DELIMITER ;
