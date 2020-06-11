CREATE TABLE [dbo].[n_customer_import_excel] (
    [import_excel_id]     INT            IDENTITY (1, 1) NOT NULL,
    [import_batch]        CHAR (36)      NOT NULL,
    [customer_name]       NVARCHAR (50)  NOT NULL,
    [customer_tel]        VARCHAR (11)   NOT NULL,
    [customer_tel_append] VARCHAR (50)   NULL,
    [customer_remarks]    NVARCHAR (500) NULL,
    [impotr_result]       INT            DEFAULT ((0)) NOT NULL,
    [import_result_msg]   NVARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([import_excel_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_n_customer_import_excel_tel]
    ON [dbo].[n_customer_import_excel]([customer_tel] ASC);

