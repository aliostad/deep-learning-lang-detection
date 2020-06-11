using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RepositoryEngine.repository;
using SlackManager.Model;

namespace SlackManager.Services
{
    public interface IRepositoryService
    {
        IHistoryRepository HistoryRepository { get;  }
        IScriptRepository ScriptRepository { get;  }
        IUserRepository UserRepository { get;  }
    }

    public class RepositoryService : IRepositoryService
    {
        public IHistoryRepository HistoryRepository { get;  }
        public IScriptRepository ScriptRepository { get;  }
        public IUserRepository UserRepository { get;  }

        public RepositoryService(IHistoryRepository historyRepository, IScriptRepository scriptRepository, IUserRepository userRepository)
        {
            HistoryRepository = historyRepository;
            ScriptRepository = scriptRepository;
            UserRepository = userRepository;
        }
    }
}
