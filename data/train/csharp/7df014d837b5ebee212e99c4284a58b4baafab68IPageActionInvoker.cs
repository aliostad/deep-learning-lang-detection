using Atlas.Forms.Interfaces.Services;
using Xamarin.Forms;

namespace Atlas.Forms.Interfaces.Pages
{
    public interface IPageActionInvoker
    {
        void InvokeInitialize(Page page, IParametersService parameters);

        void InvokeOnPageAppearing(Page page, IParametersService parameters);

        void InvokeOnPageAppeared(Page page, IParametersService parameters);

        void InvokeOnPageDisappearing(Page page, IParametersService parameters);

        void InvokeOnPageDisappeared(Page page, IParametersService parameters);

        void InvokeOnPageCaching(Page page);

        void InvokeOnPageCached(Page page);
    }
}
