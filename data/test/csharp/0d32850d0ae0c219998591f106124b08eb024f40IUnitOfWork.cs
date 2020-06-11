
using Data.Repositories;
using Data.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace  Data.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        void Commit();


        ITrainingSessionRepository TrainingSessionRepository { get; }
        ITrainingRepository TrainingRepository { get; }
        ITrainerRepository TrainerRepository { get; }
        IMaterielRepository MaterielRepository { get; }
        IContratRepository ContratRepository { get; }
        IOffreRepository OffreRepository { get; }
        IUtilisateurRepository UtilisateurRepository { get; }
        ICandidatureRepository CandidatureRepository { get; }

    }
}
