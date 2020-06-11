using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BusinessFlow.Models;
using System.Web.Security;
using BusinessFlow.ViewModels;
using Telerik.Web.Mvc;

namespace BusinessFlow.Controllers
{
    public class ClientsController : Controller
    {

        private readonly IEmployeeRepository employeeRepository;
        private readonly IEnquiryRepository enquiryRepository;
        private readonly IEnquiryDetailsRepository enquiryDetailsRepository;
        private readonly IProjectRepository projectRepository;
        private readonly ITaskRepository taskRepository;
        private readonly ITeamRepository teamRepository;
        private readonly IContactRepository contactRepository;
        private readonly ITeamProjectRepository temprojectRepository;
        private readonly IEmployeeTaskRepository empTaskRepository;

       
        public ClientsController(IEmployeeRepository employeeRepository, IProjectRepository projectRepository, ITaskRepository taskRepository,
            ITeamRepository teamRepository, IContactRepository contactRepository, IEnquiryDetailsRepository enquiryDetailsRepository,
            IEnquiryRepository enquiryRepository, ITeamProjectRepository teamprojectRepository, IEmployeeTaskRepository empTaskRepository)
        {
            this.employeeRepository = employeeRepository;
            this.projectRepository = projectRepository;
            this.taskRepository = taskRepository;
            this.teamRepository = teamRepository;
            this.contactRepository = contactRepository;
            this.enquiryRepository = enquiryRepository;
            this.enquiryDetailsRepository = enquiryDetailsRepository;
            this.temprojectRepository = teamprojectRepository;
            this.empTaskRepository = empTaskRepository;
        }
       //Index

        public ActionResult Index()
        {
            return View();

        }

    }
}
