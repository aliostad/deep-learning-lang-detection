using CourseServer.Model;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CourseServer.Views
{
    public class DispatchView : View<Dispatch>
    {
        public override string Show(List<Dispatch> recordSet)
        {
            if (Empty(recordSet)) return Success();

            JObject obj;
            JArray jArray = new JArray();
            foreach (Dispatch dispatch in recordSet)
            {
                obj = new JObject();
                obj.Add(new JProperty("Id", dispatch.Id));
                obj.Add(new JProperty("Name", dispatch.Course.Name));
                obj.Add(new JProperty("TeacherName", dispatch.Teacher.Name));
                obj.Add(new JProperty("Weekday", dispatch.Weekday));
                obj.Add(new JProperty("At", dispatch.At));
                obj.Add(new JProperty("Location", dispatch.Classroom.Location));
                obj.Add(new JProperty("Limit", dispatch.Limit));
                obj.Add(new JProperty("Current", dispatch.Current));

                jArray.Add(obj);
            }

            return Success(jArray);
        }

        public string ShowAvailableCourse(Dictionary<string, List<Dispatch>> recordList)
        {
            if (recordList == null || recordList.Count == 0)
                return Success();

            JObject jDispatch, jMajors = new JObject();

            JArray jDispatches;

            foreach (var pair in recordList)
            {
                jDispatches = new JArray();
                foreach (var dispatch in pair.Value)
                {
                    jDispatch = new JObject();
                    jDispatch.Add(new JProperty("Id", dispatch.Id));
                    jDispatch.Add(new JProperty("Name", dispatch.Course.Name));
                    jDispatch.Add(new JProperty("Description", dispatch.Course.Description));
                    jDispatch.Add(new JProperty("Weekday", dispatch.Weekday));
                    jDispatch.Add(new JProperty("At", dispatch.At));
                    jDispatch.Add(new JProperty("Limit", dispatch.Limit));
                    jDispatch.Add(new JProperty("Current", dispatch.Current));

                    jDispatches.Add(jDispatch);
                }
                
                jMajors.Add(new JProperty(pair.Key, jDispatches));
            }

            return Success(jMajors);
        }
    }
}
