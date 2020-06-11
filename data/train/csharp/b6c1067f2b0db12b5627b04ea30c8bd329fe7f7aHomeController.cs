using System.Web.Mvc;
using BlingBackend.Model.Mocked;
using BlingBackeng.Data.Interface;

namespace BlingBackend.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly IUserRepository _userRepository;
        private readonly ICategoryRepository _categoryRepository;
        private readonly ITaskRepository _taskRepository;
        private readonly IBoardRepository _boardRepository;
        private readonly IReminderRepository _reminderRepository;

        public HomeController(
            IUserRepository userRepository,
            ICategoryRepository categoryRepository,
            ITaskRepository taskRepository,
            IBoardRepository boardRepository,
            IReminderRepository reminderRepository)
        {
            _userRepository = userRepository;
            _categoryRepository = categoryRepository;
            _taskRepository = taskRepository;
            _boardRepository = boardRepository;
            _reminderRepository = reminderRepository;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult FillDb()
        {
            _userRepository.Create(MockedUsers.Patryk);
            _categoryRepository.Create(MockedCategories.HomeCategory);
            _taskRepository.Create(MockedTasks.BuyBeer);
            _boardRepository.Create(MockedBoards.HomeBoard);
            //_reminderRepository.Create(MockedReminders.GentleReminder);

            return View();
        }
    }
}