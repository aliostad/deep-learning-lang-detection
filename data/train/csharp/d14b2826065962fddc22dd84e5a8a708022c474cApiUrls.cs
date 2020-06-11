
namespace Telerik.TeamPulse.Sdk.Common
{
    public static class ApiUrls
    {
        private static readonly string apiVersion = "v1";

        public static class Teams
        {
            public static string Post = "/api/" + apiVersion + "/teams";
            public static string Put = "/api/" + apiVersion + "/teams/{0}";
            public static string GetMany = "/api/" + apiVersion + "/projects/{0}/teams";
            public static string GetOne = "/api/" + apiVersion + "/teams/{0}";
            public static string Delete = "/api/" + apiVersion + "/teams/{0}";
        }

        public static class WorkItems
        {
            public static string Post = "/api/" + apiVersion + "/workitems";
            public static string Put = "/api/" + apiVersion + "/workitems/{0}";
            public static string GetMany = "/api/" + apiVersion + "/workitems";
            public static string GetOne = "/api/" + apiVersion + "/workitems/{0}";
            public static string Delete = "/api/" + apiVersion + "/workitems/{0}";
        }

        public static class Links
        {
            public static string Post = "/api/" + apiVersion + "/links";
            public static string Put = "/api/" + apiVersion + "/links/{0}";
            public static string GetMany = "/api/" + apiVersion + "/links";
            public static string GetOne = "/api/" + apiVersion + "/links/{0}";
            public static string GetForWorkItem = "/api/" + apiVersion + "/workitems/{0}/links";
            public static string Delete = "/api/" + apiVersion + "/links/{0}";
        }

        public static class Comments
        {
            public static string Post = "/api/" + apiVersion + "/comments";
            public static string GetMany = "/api/" + apiVersion + "/comments";
            public static string GetOne = "/api/" + apiVersion + "/comments/{0}";
            public static string GetForWorkItem = "/api/" + apiVersion + "/workitems/{0}/comments";
            public static string Delete = "/api/" + apiVersion + "/comments/{0}";
        }

        public static class Attachments
        {
            public static string Post = "/api/" + apiVersion + "/workitems/{0}/attachments";
            public static string Put = "/api/" + apiVersion + "/attachments/{0}";
            public static string GetMany = "/api/" + apiVersion + "/attachments";
            public static string GetOne = "/api/" + apiVersion + "/attachments/{0}";
            public static string GetForWorkItem = "/api/" + apiVersion + "/workitems/{0}/attachments";
            public static string GetForComment = "/api/" + apiVersion + "/comments/{0}/attachments";
            public static string Delete = "/api/" + apiVersion + "/attachments/{0}";
        }

        public static class Areas
        {
            public static string Post = "/api/" + apiVersion + "/areas";
            public static string Put = "/api/" + apiVersion + "/areas/{0}";
            public static string GetMany = "/api/" + apiVersion + "/areas";
            public static string GetOne = "/api/" + apiVersion + "/areas/{0}";
            public static string GetForProject = "/api/" + apiVersion + "/projects/{0}/areas";
            public static string Delete = "/api/" + apiVersion + "/areas/{0}";
        }

        public static class Iterations
        {
            public static string Post = "/api/" + apiVersion + "/iterations";
            public static string Put = "/api/" + apiVersion + "/iterations/{0}";
            public static string GetMany = "/api/" + apiVersion + "/iterations";
            public static string GetOne = "/api/" + apiVersion + "/iterations/{0}";
            public static string GetForProject = "/api/" + apiVersion + "/projects/{0}/iterations";
            public static string Delete = "/api/" + apiVersion + "/iterations/{0}";
        }

        public static class Projects
        {           
            public static string GetMany = "/api/" + apiVersion + "/projects";
            public static string GetOne = "/api/" + apiVersion + "/projects/{0}";
        }

        public static class TimeEntries
        {
            public static string Post = "/api/" + apiVersion + "/timeentries";
            public static string Put = "/api/" + apiVersion + "/timeentries/{0}";
            public static string GetMany = "/api/" + apiVersion + "/timeentries";
            public static string GetOne = "/api/" + apiVersion + "/timeentries/{0}";
            public static string GetForTask = "/api/" + apiVersion + "/tasks/{0}/timeentries";
            public static string Delete = "/api/" + apiVersion + "/timeentries/{0}";
        }

        public static class AcceptanceCriterias
        {
            public static string Post = "/api/" + apiVersion + "/acceptancecriteria";
            public static string Put = "/api/" + apiVersion + "/acceptancecriteria/{0}";
            public static string GetMany = "/api/" + apiVersion + "/acceptancecriteria";
            public static string GetOne = "/api/" + apiVersion + "/acceptancecriteria/{0}";
            public static string GetForWorkItem = "/api/" + apiVersion + "/workitems/{0}/acceptancecriteria";
            public static string Delete = "/api/" + apiVersion + "/acceptancecriteria/{0}";
        }


        public static class TimeEntryTypes
        {
            public static string GetForProject = "/api/" + apiVersion + "/projects/{0}/timeentrytypes";
        }

        public static class Activities
        {
            public static string Get = "/api/" + apiVersion + "/activities";
            public static string GetUnread = "/api/" + apiVersion + "/activities/unread";
            public static string Put = "/api/" + apiVersion + "/activities/{0}";
            public static string PostShare = "/api/" + apiVersion + "/activities/share";
        }

        public static class Users
        {
            public static string GetAll = "/api/" + apiVersion + "/users";
            public static string GetOne = "/api/" + apiVersion + "/users/{0}";
            public static string GetCurrent = "/api/" + apiVersion + "/users/me";
        }
    }
}
