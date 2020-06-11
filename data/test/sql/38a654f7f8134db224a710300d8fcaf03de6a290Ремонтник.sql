CREATE TABLE [dbo].[Ремонтник] (
    [Специализация]            NVARCHAR (40) NULL,
    [Индентификационный номер] INT           NOT NULL,
    CONSTRAINT [aaaaaРемонтник_PK] PRIMARY KEY NONCLUSTERED ([Индентификационный номер] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ремонтник_Персонал_FK_Rule]
    ON [dbo].[Ремонтник]([Индентификационный номер] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник';


GO
EXECUTE sp_addextendedproperty @name = N'DateCreated', @value = N'28.06.2017 17:42:39', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник';


GO
EXECUTE sp_addextendedproperty @name = N'LastUpdated', @value = N'28.06.2017 17:42:41', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Ремонтник', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник';


GO
EXECUTE sp_addextendedproperty @name = N'RecordCount', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник';


GO
EXECUTE sp_addextendedproperty @name = N'Updatable', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'AppendOnly', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Специализация', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'40', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'Специализация', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'Ремонтник', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Специализация';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'AppendOnly', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Индентификационный номер', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'Индентификационный номер', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'Ремонтник', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Ремонтник', @level2type = N'COLUMN', @level2name = N'Индентификационный номер';

