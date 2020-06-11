using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TimetableCore.Data.Model;

namespace TimetableWebService.Controllers
{
	public class ClassController : EntityController<Class> { }
	public class CourseController : EntityController<Course> { }
	public class InstructorController : EntityController<Instructor> { }
	public class ScheduleController : EntityController<Schedule> { }
	public class TermController : EntityController<Term> { }
	public class UserController : EntityController<User> { }
}