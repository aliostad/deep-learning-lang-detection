USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[Switch_SMSTemplate]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Switch_SMSTemplate](
	[SMSTemplateID] [smallint] IDENTITY(1,1) NOT NULL,
	[TemplateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TemplateFor] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Message] [nvarchar](160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_Switch_SMSTemplate] PRIMARY KEY CLUSTERED 
(
	[SMSTemplateID] ASC,
	[TemplateName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Switch_SMSTemplate] ON
INSERT [dbo].[Switch_SMSTemplate] ([SMSTemplateID], [TemplateName], [TemplateFor], [Message]) VALUES (1, N'ProposeSwitch', N'IFA proposing Switch to client                    ', N'Your IFA has proposed a change to the holdings in your {%PortfolioName%} portfolio. Please log into the NAV website to see the proposed change.')
INSERT [dbo].[Switch_SMSTemplate] ([SMSTemplateID], [TemplateName], [TemplateFor], [Message]) VALUES (2, N'SecurityCode', N'Sending security code to client                   ', N'Thank you for approving the change to your portfolio. Your security code is {%SecurityCode%}.')
INSERT [dbo].[Switch_SMSTemplate] ([SMSTemplateID], [TemplateName], [TemplateFor], [Message]) VALUES (3, N'Reset', N'Resetting the switch attempt                      ', N'The security code for your {%PortfolioName%} portfolio has been reset. Please log into the NAV website to confirm the proposed change.')
INSERT [dbo].[Switch_SMSTemplate] ([SMSTemplateID], [TemplateName], [TemplateFor], [Message]) VALUES (8, N'ProposeSchemeSwitch', N'*Official do not Delete!                          ', N'Your IFA has proposed a change to the holdings in your {%param_SchemeName%} Regular Savings. Please log into the NAV website to see the proposed change.')
INSERT [dbo].[Switch_SMSTemplate] ([SMSTemplateID], [TemplateName], [TemplateFor], [Message]) VALUES (9, N'SecurityCodeScheme', N'Sending scurity code to client (scheme switch)    ', N'Thank you for approving the change to your portfolio. Your security code is {%SecurityCode%}')
SET IDENTITY_INSERT [dbo].[Switch_SMSTemplate] OFF
