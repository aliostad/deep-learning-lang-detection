CREATE DATABASE DataCollectionSystem
GO
USE [DataCollectionSystem]
GO
CREATE TABLE Operators
(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[AlgorithmModel] [nvarchar](50) NOT NULL,
	[OperatorModel] [nvarchar](50) NOT NULL,
	PRIMARY KEY (ID)
)
GO
CREATE TABLE Realizations
(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[SignName] [nvarchar](1) NOT NULL,
	PRIMARY KEY (ID)
)
GO
CREATE TABLE Operations
(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[AlgorithmModel] [nvarchar](100) NOT NULL,
	PRIMARY KEY (ID)
)
GO
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES ('A(B)', 'íà÷àëî âûïîëíåíèÿ', 'A(B)', 'A(B)');
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES ('A(E)', 'êîíåö âûïîëíåíèÿ', 'A(E)', 'A(E)');
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES ('<<', 'íà÷àëî öûêëà', '<<', 'F(op)[<<]');
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES ('>>', 'êîíåö öûêëà', '>>', 'F(op)[>>]');
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES ('[', 'îòêðûâàþùÿÿ ñêîáêà', '[', '[');
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES (']', 'çàêðûâàþùÿÿ ñêîáêà', ']', ']');
INSERT INTO Operators (Name, Description, AlgorithmModel, OperatorModel)
		VALUES ('||', 'èëè', '||', '||');
GO
INSERT INTO Realizations (Name, SignName)
		VALUES ('àïïàðàòíàÿ', 'à');
INSERT INTO Realizations (Name, SignName)
		VALUES ('ïðîãðàììíàÿ', 'p');
GO
INSERT INTO Operations (Name, Description, AlgorithmModel)
		VALUES ('C(p1/p2)', 'èíèöèàëèçàöèÿ êîíñòàíòû', 'E(C;(p1);(p2))');
INSERT INTO Operations (Name, Description, AlgorithmModel)
		VALUES ('F(p1,p2)', 'èñ÷èñëåíèå ôóíêöèè', 'E(C:N(p1);(p1);(p2))');
INSERT INTO Operations (Name, Description, AlgorithmModel)
		VALUES ('I(p1/p2)', 'èçìåðåíèÿ', 'E(S:N,g;(p1);(p2,p3))');
INSERT INTO Operations (Name, Description, AlgorithmModel)
		VALUES ('delay(t)', 'çàäåðæêà', 'E(C:I(p1*b(T-t));(p1);(p2))');
GO