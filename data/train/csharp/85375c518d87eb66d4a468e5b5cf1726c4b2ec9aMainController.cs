using controllers;
using Ninject;

namespace HospitalRegistryControllers
{
    public class MainController : Controller
    {
        private Controller doctorsController;
        private Controller patientController;
        private Controller scheduleController;
        private Controller specializationsController;

        public MainController(
            [Named("DoctorsController")]Controller doctorsController,
            [Named("PatientController")]Controller patientController,
            [Named("ScheduleController")]Controller scheduleController,
            [Named("SpecializationsController")]Controller specializationsController
        ) : base("Main")
        {
            this.doctorsController = doctorsController;
            this.patientController = patientController;
            this.scheduleController = scheduleController;
            this.specializationsController = specializationsController;
        }

        public override bool RunChoice(string choice)
        {
            var exit = false;
            switch (choice)
            {
                case "1":
                    doctorsController.Run();
                    break;
                case "2":
                    specializationsController.Run();
                    break;
                case "3":
                    patientController.Run();
                    break;
                case "4":
                    scheduleController.Run();
                    break;
                case "5":
                    exit = true;
                    break;
            }
            return exit;
        }  
    }
}