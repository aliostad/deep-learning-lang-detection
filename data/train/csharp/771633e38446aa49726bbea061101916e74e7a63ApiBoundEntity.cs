using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MongoDB.Bson.Serialization.Attributes;

namespace Mbrit.StreetFoo.Entities
{
    public abstract class ApiBoundEntity : Entity
    {
        [BsonElement(ApiUser.ApiKeyKey)]
        public string ApiKey { get; set; }

        public void SetApi(IApiUserSource api)
        {
            if (api == null)
                throw new ArgumentNullException("api");
            if (api.ApiUser == null)
                throw new InvalidOperationException("'api.ApiUser' is null.");

            this.ApiKey = api.ApiUser.ApiKey;
        }
    }
}
