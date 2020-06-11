namespace UPE_ONS.Controllers
{
    class FactoryController
    {
        public static FactoryController instance;

        public PrevEOL_Controller PrevEOL_Controller { get; internal set; }
        public ParqueEolicoController ParqueEolicoController { get; internal set; }
        public PrevisorController PrevisorController { get; internal set; }
        public CalibradorController CalibradorController { get; internal set; }
        public CPTEC_Controller CPTEC_Controller { get; internal set; }

        private FactoryController()
        {
            this.PrevEOL_Controller = new PrevEOL_Controller();
            this.ParqueEolicoController = new ParqueEolicoController();
            this.PrevisorController = new PrevisorController();
            this.CalibradorController = new CalibradorController();
            this.CPTEC_Controller = new CPTEC_Controller();
        }

        public static FactoryController getInstance()
        {
            if (instance == null)
                instance = new FactoryController();
            return instance;
        }
    }
}