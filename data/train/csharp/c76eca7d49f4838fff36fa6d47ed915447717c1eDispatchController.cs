using CourseProvider;
using CourseServer.Framework;
using CourseServer.Model;
using CourseServer.Repositories;
using CourseServer.Views;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CourseServer.Controllers
{
    public class DispatchController : Controller
    {
        public string Index()
        {
            DispatchView view = new DispatchView();
            DispatchRepository dispatchRepo = new DispatchRepository();

            var result = dispatchRepo.GetAvailableCourse();
            return view.ShowAvailableCourse(result);
        }

        public string DispatchStudent()
        {
            var view = new GenericView();
            DispatchRepository dispatchRepo = new DispatchRepository();

            var result = dispatchRepo.GetDispatchStudent(Auth.User().Id);

            return view.Show(result);
        }
    }
}
