using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WorktileSDK.API;

namespace WorktileSDK
{
    public class APIResource
    {
        public UserAPI UserAPI { get; private set; }
        public TeamAPI TeamAPI { get; private set; }
        public ProjectAPI ProjectAPI { get; private set; }
        public EntryAPI EntryAPI { get; private set; }
        public EventAPI EventAPI { get; private set; }
        public FileAPI FileAPI { get; private set; }
        public PageAPI PageAPI { get; private set; }
        public PostAPI PostAPI { get; private set; }
        public TaskAPI TaskAPI { get; private set; }

        public APIResource(Client client)
        {
            this.UserAPI = new UserAPI(client);
            this.TeamAPI = new TeamAPI(client);
            this.ProjectAPI = new ProjectAPI(client);
            this.EntryAPI = new EntryAPI(client);
            this.EventAPI = new EventAPI(client);
            this.FileAPI = new FileAPI(client);
            this.PageAPI = new PageAPI(client);
            this.PostAPI = new PostAPI(client);
            this.TaskAPI = new TaskAPI(client);
        }
    }
}
