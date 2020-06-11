var CachingMessageSender = Class.create();
CachingMessageSender.prototype =
{
	/*final*/ _internalMessageSender: null,

	_caching: 0,
	_cache: [],

	initialize: function(internalMessageSender)
	{
		this._internalMessageSender = internalMessageSender;
	},

	sendMessage: function(message)
	{
		if (this._caching > 0)
		{
			this._cache.push(message);
		}
		else
		{
			this._internalMessageSender.sendMessage(message);
		}
	},

	startCaching: function()
	{
		this._caching++;
	},

	stopCaching: function()
	{
		this._caching--;

		if (this._caching <= 0)
		{
			for (var i = 0; i < this._cache.length; i++)
			{
				var message = this._cache[i];
				this._internalMessageSender.sendMessage(message);
			}

			this._cache = [];
		}		
	}
};
