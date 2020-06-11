CREATE TABLE [dbo].[_UserSettings] (
    [SettingID]  NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [UserID]     VARCHAR (25)   NOT NULL,
    [PW]         VARCHAR (25)   NULL,
    [Settings]   VARCHAR (5000) NULL,
    [IsReadOnly] BIT            NULL,
    CONSTRAINT [PK__UserSettings] PRIMARY KEY CLUSTERED ([SettingID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'_UserSettings', @level2type = N'COLUMN', @level2name = N'IsReadOnly';

