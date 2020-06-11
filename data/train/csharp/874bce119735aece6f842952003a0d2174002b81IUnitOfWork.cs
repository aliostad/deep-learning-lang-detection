

using Data.Repositories;

namespace Data.Infrastructure
{
    public interface IUnitOfWork
    {
        void Commit();

        IUserRepository UserRepository { get; }
        IBureauRepository BureauRepository { get; }
        IRegionRepository RegionRepository { get; }
        ISocieteAssuranceRepository SocieteAssuranceRepository { get; }
        IContratMaintennaceRepository ContratMaintennaceRepository { get; }
        IContratAssuranceRepository ContratAssuranceRepository { get; }
        IContratGarantieRepository ContratGarantieRepository { get; }
        ISocieteMaintenanceRepository SocieteMaintenanceRepository { get; }
        IAchatRepository AchatRepository { get; }
        IFournisseurRepository FournisseurRepository { get; }
        IBatimentRepository BatimentRepository { get; }
        IInventaireRepository InventaireRepository { get; }
        IBiensRepository BiensRepository { get; }
        IServiceRepository ServiceRepository { get; }
        IParc_autoRepository Parc_autoRepository { get; }
        IGouvernoratRepository GouvernoratRepository { get; }

        IEtageRepository EtageRepository { get; }
    IPersonnelRepository PersonnelRepository { get; }
        IRoleRepository RoleRepository { get; }
        ICategorie_materielRepository Categorie_materielRepository { get; }
        IServiceDRepository ServiceDRepository { get; }
        IUtilisateurRepository UtilisateurRepository { get; }
        IDelegationRepository DelegationRepository { get; }

        IOrganisationRepository OrganisationRepository { get; }

        IPaysRepository PaysRepository { get; }

        IDirectionRepository DirectionRepository { get; }
      

    }
}
