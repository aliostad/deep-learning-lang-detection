

using Data.Repositories;

namespace Data.Infrastructure
{
    public interface IUnitOfWork
    {
        void Commit();

         ILocalitéRepository LocalitéRepository { get; }
        IBureauRepository BureauRepository { get; }
        IRegionRepository RegionRepository { get; }
     
        IContratRepository ContratRepository { get; }
        IContratBienRepository ContratBienRepository { get; }
        IAchatRepository AchatRepository { get; }
        IFournisseurRepository FournisseurRepository { get; }
        IBatimentRepository BatimentRepository { get; }
        IInventaireRepository InventaireRepository { get; }
        
        IServiceRepository ServiceRepository { get; }
        IParc_autoRepository Parc_autoRepository { get; }
        IGouvernoratRepository GouvernoratRepository { get; }
       
        IVehiculeRepository VehiculeRepository { get; }
        ICategorieRepository CategorieRepository { get; }
        IEtageRepository EtageRepository { get; }
        IPersonnelRepository PersonnelRepository { get; }
        IRoleRepository RoleRepository { get; }
        IMouvementBienRepository MouvementBienRepository { get; }
        IMouvementVehiculeRepository MouvementVehiculeRepository { get; }
        IServiceDRepository ServiceDRepository { get; }
        IUtilisateurRepository UtilisateurRepository { get; }
        IDelegationRepository DelegationRepository { get; }

        IOrganisationRepository OrganisationRepository { get; }

        IPaysRepository PaysRepository { get; }

        IDirectionRepository DirectionRepository { get; }
        IInventaireBienRepository InventaireBienRepository { get; }
        IInventaireVehiculeRepository InventaireVehiculeRepository { get; }
        IDepotRepository DepotRepository { get; }
        IBienRepository BienRepository { get; }



    }
}
