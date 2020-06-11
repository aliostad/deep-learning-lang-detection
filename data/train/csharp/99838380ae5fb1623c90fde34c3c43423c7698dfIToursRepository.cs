using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace mtm.Tourism.Repository
{
    public class IToursRepository
    {
        private CategoryRepository _CategoryRepository;

        /// <summary>
        /// 
        /// </summary>
        public CategoryRepository category
        {
            get
            {
                if (_CategoryRepository == null)
                    _CategoryRepository = new CategoryRepository();
                return _CategoryRepository;
            }
        }
        private ToursRepository _ToursRepository;

        /// <summary>
        /// 
        /// </summary>
        public ToursRepository tours
        {
            get
            {
                if (_ToursRepository == null)
                    _ToursRepository = new ToursRepository();
                return _ToursRepository;
            }
        }
        private VariantyRepository _VariantyRepository;

        /// <summary>
        /// 
        /// </summary>
        public VariantyRepository variants
        {
            get
            {
                if (_VariantyRepository == null)
                    _VariantyRepository = new VariantyRepository();
                return _VariantyRepository;
            }
        }
    }
}
