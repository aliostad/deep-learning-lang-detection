-- =============================================
-- Author:		Eduardo Getassi da Rosa
-- Project:		Clinica
-- Create date: 10/10/2013
-- Description:	Stored Procedure que insere um registro da tabela Logradouro
-- =============================================

IF EXISTS 
(
	SELECT * 
		FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE 
		SPECIFIC_SCHEMA = 'dbo' AND
		SPECIFIC_NAME = 'LogradouroInsert' 
)
   DROP PROCEDURE dbo.LogradouroInsert
GO

CREATE PROCEDURE LogradouroInsert

	StringBuilder temp = new StringBuilder();
	Boolean flag = false; 
	foreach (Campo campo in projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos) 
	{
		if (flag)
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
		flag = true;
	}
	return temp.ToString().Substring(0, temp.ToString().Length - 3); 

AS
	INSERT INTO Logradouro 
	(

	StringBuilder temp = new StringBuilder(); 
	Boolean flag = false;
	foreach (Campo campo in projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos)
	{
		if (flag)
		{
			temp.Append("       ");
			temp.Append(campo.Nome);
			temp.AppendLine(", ");
		}
		flag = true; 
	}
	return temp.ToString().Substring(0, temp.ToString().Length - 4);

	) 
	VALUES
	(

	StringBuilder temp = new StringBuilder(); 
	Boolean flag = false;
	foreach (Campo campo in projeto.Tabelas.Find(p => p.Nome.Equals(projeto.Tabela)).Campos)
	{
		if (flag)
		{
			temp.Append("       @");
			temp.Append(campo.Nome);
			temp.AppendLine(", ");
		}
		flag = true;
	}
	return temp.ToString().Substring(0, temp.ToString().Length - 4);

	)
GO

