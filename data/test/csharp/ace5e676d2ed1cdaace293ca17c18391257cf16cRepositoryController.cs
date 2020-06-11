using System.Web.Mvc;

namespace PetParadiseHotel.Infrastructure
{
    public class RepositoryController : Controller
    {
        private Repository _repository;
         
        protected Repository Repository {
            get { return _repository; }
        }

        [NonAction]
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (Session["repository"] == null)
            {
                _repository = new Repository();
                Session["repository"] = _repository;
            }
            else
            {
                _repository = (Repository)Session["repository"];
            }

            base.OnActionExecuting(filterContext);
        }
    }
}