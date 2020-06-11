 	 
 EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'LeadsReport',
    @recipients = 'lei.shi@move.com',
    @query = 'SELECT * FROM ##tempContacts1' ,
    @execute_query_database = 'PorchLeadsSurveyContacts',
    @subject = 'contacts for porch leads.csv',
    @query_attachment_filename = 'ContactsForPorchLeads.csv',
    @query_result_header = 1,
--    @query_result_width = 32767, -- can go to 32767 for query width
    @query_result_separator = ',',
    @exclude_query_output = 0,
--	@append_query_error = 1,
	@query_result_no_padding =1,
    @attach_query_result_as_file = 1 ;
