using System;
using Rn.Mailer.DAL.Entities;

namespace Rn.Mailer.DALTests.TestSupport.Builders
{
    public class MailApiKeyEntityBuilder
    {
        private readonly MailApiKeyEntity _apiKey;

        public MailApiKeyEntityBuilder()
        {
            _apiKey = new MailApiKeyEntity();
        }

        public MailApiKeyEntityBuilder AsValidObject()
        {
            _apiKey.Id = 1;
            _apiKey.Enabled = true;
            _apiKey.CreationDateUtc = DateTime.UtcNow;
            _apiKey.MailAccountId = 1;
            _apiKey.MailSendCount = 10;
            _apiKey.ApiKey = "DC6E9F45-EB0D-4139-8A54-289EB3CF35EB";
            _apiKey.MailAccount = new MailAccountEntityBuilder().AsValidObject().Build();

            return this;
        }

        public MailApiKeyEntity Build()
        {
            return _apiKey;
        }
    }
}
