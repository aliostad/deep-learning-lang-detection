using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayer.Repository;

namespace DataAccessLayer
{
    public class Facade
    {
        private AboutRepository aboutRepository;
        private RoleRepository roleRepository;
        private ContactsRepository contactsRepository;
        private NewsRepository newsRepository;
        private SponserRepository sponsorRepository;
        private TeamRepository teamRepository;
        private TournamentRepository tournamentRepository;
        private EnglishRepository englishRepository; 
        private PictureRepository pictureRepository;
        private PlayerRepository playerRepository; 
        

        public AboutRepository GetAboutRepository()
        {
            if (aboutRepository == null)
            {
                aboutRepository = new AboutRepository();
            }
            return aboutRepository;
        }

        public RoleRepository GetRoleRepository()
        {
            if (roleRepository == null)
            {
                roleRepository = new RoleRepository();
            }
            return roleRepository;
        }

        public ContactsRepository GetContactRepository()
        {
            if (contactsRepository == null)
            {
                contactsRepository = new ContactsRepository();
            }
            return contactsRepository;
        }

        public NewsRepository GetNewsRepository()
        {
            if(newsRepository == null)
            {
                newsRepository = new NewsRepository();
            }
            return newsRepository;
        }

        public SponserRepository GetSponsorRepository()
        {
            if(sponsorRepository == null)
            {
                sponsorRepository = new SponserRepository();
            }
            return sponsorRepository;
        }

        public TeamRepository GetTeamRepository()
        {
            if(teamRepository == null)
            {
                teamRepository = new TeamRepository();
            }
            return teamRepository;
        }

        public TournamentRepository GetTournamentRepository()
        {
            if(tournamentRepository == null)
            {
                tournamentRepository = new TournamentRepository();
            }
            return tournamentRepository;
        }


        public EnglishRepository GetEnglishRepository()
        {
            if (englishRepository == null)
            {
                englishRepository = new EnglishRepository();
            }
            return englishRepository;
        }   

        public PictureRepository GetPictureRepository()
        {
            if (pictureRepository == null)
            {
                pictureRepository = new PictureRepository();
            }
            return pictureRepository;

        }

        public PlayerRepository GetPlayerRepository()
        {
            if (playerRepository == null)
            {
                playerRepository = new PlayerRepository();
            }
            return playerRepository;
        }
    }
}
