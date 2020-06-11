namespace OO_PickNDrive.DAL
{
    public class Repository
    {
        public DjelatnikRepository djelatnikRepository;
        public KlijentRepository klijentRepository;
        public MjestoRepository mjestoRepository;
        public RacunRepository racunRepository;
        public RacunStatusRepository racunStatusRepository;
        public VoziloRepository voziloRepository;
        public VoziloKategorijaRepository voziloKategorijaRepository;
        public VoziloStatusRepository voziloStatusRepository;

        public Repository()
        {
            djelatnikRepository = new DjelatnikRepository();
            klijentRepository = new KlijentRepository();
            mjestoRepository = new MjestoRepository();
            racunRepository = new RacunRepository();
            racunStatusRepository = new RacunStatusRepository();
            voziloRepository = new VoziloRepository();
            voziloKategorijaRepository = new VoziloKategorijaRepository();
            voziloStatusRepository = new VoziloStatusRepository();
        }

    }
}
