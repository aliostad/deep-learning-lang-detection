-- =============================================
-- Author:		Eduardo Getassi da Rosa
-- Project:		Clinica
-- Create date: 10/10/2013
-- Description:	Stored Procedure que atualiza um registro da tabela Logradouro
-- =============================================

IF EXISTS 
(
	SELECT * 
		FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE 
		SPECIFIC_SCHEMA = 'dbo' AND
		SPECIFIC_NAME = 'LogradouroUpdate' 
)
   DROP PROCEDURE dbo.LogradouroUpdate
GO

CREATE PROCEDURE LogradouroUpdate

	StringBuilder temp = new StringBuilder();
	foreach (Campo campo in projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos)
	{
		temp.Append("   @"); 
		temp.Append(campo.Nome);
		temp.Append(" ");
		if(campo.Tipo.Equals("varchar"))
		{
			temp.Append(campo.Tipo);
			temp.Append("(");
			temp.Append(campo.TamanhoMax);
			temp.Append(")");
		}
		else
		{ 
			temp.Append(campo.Tipo); 
		}
		if(Convert.ToBoolean(campo.PermiteNulo))
		{
			temp.Append(" = null");
		}
		temp.AppendLine(",");
	} 
	return temp.ToString().Substring(0, temp.ToString().Length - 3);

AS
	UPDATE Logradouro
		SET

	StringBuilder temp = new StringBuilder(); 
	Boolean flag = false;
	foreach (Campo campo in projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos)
	{
		if (flag)
		{
			temp.Append("           ");
			temp.Append(campo.Nome);
			temp.Append(" = @");
			temp.Append(campo.Nome);
			temp.AppendLine(", ");
		}
		flag = true;
	} 
	return temp.ToString().Substring(0, temp.ToString().Length - 4);

	WHERE 

	Campo campo = projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos.Find(p => Convert.ToBoolean(p.ChavePrimaria) == true);
	return String.Concat("		", campo.Nome, " = @", campo.Nome);

GO

