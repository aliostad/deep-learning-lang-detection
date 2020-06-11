using System;
using Model;

namespace Repository
{
    public class ProposalRepository
    {
        public void Save(Proposal obj)
        {
            try
            {
                ProposalRepository repository = new ProposalRepository();
             //   repository.Save(obj);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void Delete(Proposal obj)
        {
            try
            {
                ProposalRepository repository = new ProposalRepository();
            //    repository.Delete(obj);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void Update(Proposal obj)
        {
            try
            {
                ProposalRepository repository = new ProposalRepository();
            //    repository.Update(obj);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}