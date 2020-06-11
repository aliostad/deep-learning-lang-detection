using BusinessLogic.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic
{
    public partial class UnitOfWork
    {
        private ListingRepository _ListingRepository;
        public ListingRepository ListingRepository
        {
            get
            {
                if (_ListingRepository == null)
                {
                    _ListingRepository = new ListingRepository();
                }

                return _ListingRepository;
            }
        }

        private UserProfileRepository _UserProfileRepository;
        public UserProfileRepository UserProfileRepository
        {
            get
            {
                if (_UserProfileRepository == null)
                {
                    _UserProfileRepository = new UserProfileRepository();
                }

                return _UserProfileRepository;
            }
        }

        private EvaluationRepository _EvaluationRepository;
        public EvaluationRepository EvaluationRepository
        {
            get
            {
                if (_EvaluationRepository == null)
                {
                    _EvaluationRepository = new EvaluationRepository();
                }

                return _EvaluationRepository;
            }
        }
    }
}
