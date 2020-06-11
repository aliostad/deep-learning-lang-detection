using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TopDownAutomate;

namespace TDFU.classes.Control
{
    public class MainController
    {
        public ArquivoController arquivoController = new ArquivoController();
        public AutoPrintController autoPrintController = new AutoPrintController();
        public BancoController bancoController = new BancoController();
        public BancoInfoController bancoInfoController = new BancoInfoController();
        public ClienteController clienteController = new ClienteController();
        public ControleController controleController = new ControleController();
        public NavegadorController navegadorController = new NavegadorController();
        public ObjetoBancoController objetoBancoController = new ObjetoBancoController();
        public ObjetoWebController objetoWebController = new ObjetoWebController();
        public RedeController redeController = new RedeController();
        public SACController sacController = new SACController();
        public SugestController sugestController = new SugestController();
        private UsuarioController usuarioController;
        public WebController webController = new WebController();
        public WebInfoController webInfoController = new WebInfoController();

        public UsuarioController UsuarioController
        {
            get
            {
                return usuarioController;
            }

            set
            {
                usuarioController = value;
            }
        }

        public MainController()
        {
           UsuarioController = new UsuarioController();
        }

    }
}
