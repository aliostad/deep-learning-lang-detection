DECLARE @i_new_id INTEGER;
EXECUTE sp_com_new_post 
	@nvc_sender_id	= 'cfvbaibai',
	@nvc_content	= 'Test Post 1',
	@i_new_id		= @i_new_id OUTPUT;

EXECUTE sp_com_new_reply
	@i_reply_to		= @i_new_id,
	@nvc_sender_id	= 'ohaoha',
	@nvc_content	= 'Test Reply 11';

EXECUTE sp_com_new_reply
	@i_reply_to		= @i_new_id,
	@nvc_sender_id	= 'ohaoha',
	@nvc_content	= 'Test Reply 12';

EXECUTE sp_com_new_post 
	@nvc_sender_id	= 'cfvbaibai',
	@nvc_content	= 'Test Post 2',
	@i_new_id		= @i_new_id OUTPUT;

EXECUTE sp_com_new_reply
	@i_reply_to		= @i_new_id,
	@nvc_sender_id	= 'xxccc',
	@nvc_content	= 'Test Reply 21';

EXECUTE sp_com_new_post 
	@nvc_sender_id	= 'cfvbaibai',
	@nvc_content	= 'Test Post 3',
	@i_new_id		= @i_new_id OUTPUT;