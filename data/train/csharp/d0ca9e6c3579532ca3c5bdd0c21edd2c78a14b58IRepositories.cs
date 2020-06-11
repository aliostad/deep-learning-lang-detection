namespace RVMS.Model.Repository.Interfaces
{
    public interface IRepositories
    {
        ILinijeRepository LinijeRepository { get; }
        IMedjustanicnaRastojanjaRepository MedjustanicnaRastojanjaRepository { get; }
        IMestaRepository MestaRepository { get; }
        IPrevozniciRepository PrevozniciRepository { get; }
        IRelacijeRepository RelacijeRepository { get; }
        IStajalistaRepository StajalistaRepository { get; }
        IStajalistaLinijeRepository StajalistaLinijeRepository { get; }
        void Save();
    }
}