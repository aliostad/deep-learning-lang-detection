using admin.DAL.Repositories;
using net_api.DAL.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace net_api.DAL.infrastructure
{
    public class UnitOfWork
    {
        private GameRepository gameRepository;
        private UserRepository userRepository;
        private SettingRepository settingRepository;

        public GameRepository GameRepository
        {
            get
            {
                if(gameRepository == null)
                {
                    gameRepository = new GameRepository();
                }
                return gameRepository;
            }
        }

        public UserRepository UserRepository
        {
            get
            {
                if (userRepository == null)
                {
                    userRepository = new UserRepository();
                }
                return userRepository;
            }
        }

        public SettingRepository SettingRepository
        {
            get
            {
                if (settingRepository == null)
                {
                    settingRepository = new SettingRepository();
                }
                return settingRepository;
            }
        }

    }
}
