using MedicalDocManagment.DAL.Manager;
using MedicalDocManagment.DAL.Repository.Interfaces.ChildCard;
using System;

namespace MedicalDocManagment.DAL.Repository.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IPositionRepository PositionRepository { get; }
        IClassMkhRepository ClassMkhRepository { get; }
        IBlockMkhRepository BlockMkhRepository { get; }
        INosologyMkhRepository NosologyMkhRepository { get; }
        IDiagnosisMkhRepository DiagnosisMkhRepository { get; }
        IChildrenCardsRepository ChildrenCardsRepository { get; }
        IParentRepository ParentRepository { get; }
        IParentChildCardRepository ParentChildCardRepository { get; }
        IImageRepository ImageRepository { get; }
        IPediatriciansExaminationsRepository PediatriciansExaminationsRepository { get; }
        INeurologistsExaminationsRepository NeurologistsExaminationsRepository { get; }
        ISpeechTherapistsExaminationsRepository SpeechTherapistsExaminationsRepository { get; }
        ITherapeuticProceduresRepository TherapeuticProceduresRepository { get; }
        IRehabilitationsRepository RehabilitationsRepository { get; }
        IVisitsRepository VisitsRepository { get; }

        UsersManager UsersManager { get; }

        bool Save();
    }
}
