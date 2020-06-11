using GlumOrigins.Client.Controllers.Graphic;
using UnityEngine;

namespace GlumOrigins.Client.Controllers
{
    public class GameController : MonoBehaviour
    {
        private NetworkController networkController;
        private WorldController worldController;

        private TileGraphicController tileGraphicController;
        private PlayerCharacterGraphicController playerCharacterGraphicController;

        [Header("Connection Settings")]
        [SerializeField]
        private string ipAddress;
        [SerializeField]
        private int port;

        private void Start()
        {
            networkController = new NetworkController();
            worldController =  new WorldController();
            tileGraphicController = new TileGraphicController();
            playerCharacterGraphicController = new PlayerCharacterGraphicController();
            PlayerController.Initialize();

            networkController.Connect(ipAddress, port);
        }

        private void Update()
        {
            networkController.Update();
        }

        private void OnApplicationQuit()
        {
            networkController.Client.Disconnect();
        }
    }
}
