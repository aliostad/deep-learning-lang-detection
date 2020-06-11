-- =============================================
-- Author:		Eduardo Getassi da Rosa
-- Project:		Clinica
-- Create date: 10/10/2013
-- Description:	Stored Procedure que consulta um registro da tabela Logradouro a partir do id
-- =============================================

IF EXISTS 
(
	SELECT * 
		FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE 
		SPECIFIC_SCHEMA = 'dbo' AND
		SPECIFIC_NAME = 'LogradouroFindById' 
)
   DROP PROCEDURE dbo.LogradouroFindById
GO

CREATE PROCEDURE LogradouroFindById

	Campo campo = projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos.Find(p => Convert.ToBoolean(p.ChavePrimaria) == true);
	return String.Concat("@", campo.Nome, " ", campo.Tipo);


AS
	SELECT 

	StringBuilder sb = new StringBuilder();
	foreach(Campo campo in projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos)
	{
		sb.Append("		");
		sb.Append(campo.Nome);
		sb.AppendLine(",");
	}
	return sb.ToString().Substring(0, sb.ToString().Length - 3);

	FROM Logradouro
	WHERE

	Campo campo = projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos.Find(p => Convert.ToBoolean(p.ChavePrimaria) == true);
	return String.Concat("		", campo.Nome, " = @", campo.Nome);

GO

