using System;

namespace Rs.Dnevnik.Ris.Interfaces.Repositories
{
    public interface IRepositoryFactory : IDisposable
    {
        INovinskeKuceRepository NovinskeKuceRepository { get; } 

        ISektoriRepository SektoriRepository { get; }

        IOdeljenjaRepository OdeljenjaRepository { get; }

        IRadniciRepository RadniciRepository { get; }

        IPublikacijeRepository PublikacijeRepository { get; }

        IRubrikeRepository RubrikeRepository { get; }

        ITipoviTekstovaRepository TipoviTekstovaRepository { get; }

        IOceneRepository OceneRepository { get; }

        IRadniNaloziRepository RadniNaloziRepository { get; }

        IAgencijskeVestiRepository AgencijskeVestiRepository { get; }

        IAgencijeRepository AgencijeRepository { get; }

        IKonfiguracijaRepository KonfiguracijaRepository { get; }

        IKonverzijaRepository KonverzijaRepository { get; }

        IMaterijalRepository MaterijalRepository { get; }

        ITekstoviRepository TekstoviRepository { get; }

        IGrupeMaterijalaRepository GrupeMaterijalaRepository { get; }

        IKorisnickiNaloziRepository KorisnickiNaloziRepository { get; }

        IUlogeRadnikaRepository UlogeRadnikaRepository { get; }
    }
}