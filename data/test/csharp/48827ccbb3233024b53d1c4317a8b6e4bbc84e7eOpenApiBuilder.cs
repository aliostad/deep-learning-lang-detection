#region References

using VkApi.Abstract;
using VkApi.Core.Methods;
using VkApi.Global;

#endregion

namespace VkApi.Core.Builders
{
    /// <summary>
    /// Класс построения строк Api не требующих access_token
    /// </summary>
    internal class OpenApiBuilder : VkUrlBuilder<ApiMethod>
    {
        #region Properties

        protected override string Url
        {
            get { return VkApiConstants.VkApiUrl; }
        }

        #endregion

        #region Constructors

        public OpenApiBuilder(ApiMethod apiMethod, IApiSettings settings) : base(apiMethod, settings)
        {
        }

        #endregion
    }
}