-- =============================================
-- Author:		Eduardo Getassi da Rosa
-- Project:		Clinica
-- Create date: 10/10/2013
-- Description:	Stored Procedure que lista todos os registros da tabela Logradouro
-- =============================================

IF EXISTS 
(
	SELECT * 
		FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE 
		SPECIFIC_SCHEMA = 'dbo' AND
		SPECIFIC_NAME = 'LogradouroList' 
)
   DROP PROCEDURE dbo.LogradouroList
GO

CREATE PROCEDURE LogradouroList
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
GO

