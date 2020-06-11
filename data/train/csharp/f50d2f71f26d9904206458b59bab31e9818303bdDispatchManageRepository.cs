using CourseServer.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CourseServer.Repositories.Advance
{
    public class DispatchManageRepository : Repository
    {
        public List<Dictionary<string, object>> GetAll()
        {
            List<Dictionary<string, object>> Ret = null;
            using (var context = GetDbContext())
            {
                DbSet<Dispatch> dispatches = context.Set<Dispatch>();

                if (dispatches.Count() <= 0)
                {
                    return Ret;
                }

                Dictionary<string, object> dispatchInfo;
                Ret = new List<Dictionary<string, object>>(dispatches.Count());

                var result = dispatches.ToList();

                foreach (var dispatch in result)
                {
                    dispatchInfo = new Dictionary<string, object>();
                    dispatchInfo.Add("Id", dispatch.Id);
                    dispatchInfo.Add("Name", dispatch.Course.Name);
                    dispatchInfo.Add("ClassroomId", dispatch.ClassroomId);
                    dispatchInfo.Add("Location", dispatch.Classroom.Location);
                    dispatchInfo.Add("TeacherId", dispatch.TeacherId);
                    dispatchInfo.Add("TeacherName", dispatch.Teacher.Name);
                    dispatchInfo.Add("Weekday", dispatch.Weekday);
                    dispatchInfo.Add("At", dispatch.At);
                    dispatchInfo.Add("Limit", dispatch.Limit);

                    Ret.Add(dispatchInfo);
                }
            }

            return Ret;
        }

        public bool Create(string weekday, DateTime at,
            int limit,
            int teacherId, int courseId, int roomId)
        {
            bool bRet = false;
            using (var context = GetDbContext())
            {
                DbSet<Course> courses = context.Set<Course>();
                DbSet<Teacher> teachers = context.Set<Teacher>();
                DbSet<Classroom> classrooms = context.Set<Classroom>();

                var course = courses.Where(c => c.Id == courseId).FirstOrDefault();
                var teacher = teachers.Where(t => t.Id == teacherId).FirstOrDefault();
                var classroom = classrooms.Where(c => c.Id == roomId).FirstOrDefault();

                if (course == null || teacher == null || classroom == null)
                {
                    return bRet;
                }

                DbSet<Dispatch> dispatches = context.Set<Dispatch>();
                Dispatch dispatch = new Dispatch() { Course = course, Teacher = teacher,
                    Weekday = weekday, At = at, Limit = limit, Enable = true,
                    Classroom = classroom};

                dispatches.Add(dispatch);

                context.SaveChanges();

                bRet = true;
            }
            return bRet;
        }

        public bool Destroy(int id)
        {
            bool bRet = false;

            using (var context = GetDbContext())
            {
                DbSet<Dispatch> dispatches = context.Set<Dispatch>();
                Dispatch dispatch = dispatches.Where(d => d.Id == id).FirstOrDefault();

                if (dispatch != null)
                {
                    dispatches.Remove(dispatch);

                    context.SaveChanges();
                }

                bRet = true;
            }

            return bRet;
        }

        public bool Update(int id, 
            string weekday, DateTime at,
            int limit,
            int teacherId, int roomId, bool enable)
        {
            bool bRet = false;

            using (var context = GetDbContext())
            {
                DbSet<Dispatch> dispatches = context.Set<Dispatch>();
                DbSet<Teacher> teachers = context.Set<Teacher>();
                DbSet<Classroom> classrooms = context.Set<Classroom>();

                Dispatch dispatch = dispatches.Where(d => d.Id == id).FirstOrDefault();
                var teacher = teachers.Where(t => t.Id == teacherId).FirstOrDefault();
                var classroom = classrooms.Where(c => c.Id == roomId).FirstOrDefault();

                if (dispatch == null || teacher == null || classroom == null)
                {
                    return bRet;                    
                }

                dispatch.Weekday = weekday;
                dispatch.At = at;
                dispatch.Limit = limit;
                dispatch.Teacher = teacher;
                dispatch.Classroom = classroom;
                dispatch.Enable = enable;

                context.SaveChanges();

                bRet = true;
            }

            return bRet;
        }
    }
}
