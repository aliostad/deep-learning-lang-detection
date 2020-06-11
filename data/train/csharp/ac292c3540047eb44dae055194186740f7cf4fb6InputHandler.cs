using UnityEngine;
using System.Collections;

public class InputHandler : MonoBehaviour
{
    
    public void UpgradeTrees() { GameController.controller.treeController.Upgrade(); }
    public void UpgradeRefinery() { GameController.controller.refineryController.Upgrade(); }
    public void RefineAndSell() { GameController.controller.refineryController.RefineAndSell(); }
    public void PayBank() { if (GameController.controller.Money > 0) GameController.controller.PayBank(GameController.controller.Debt < GameController.controller.Money ? GameController.controller.Debt : GameController.controller.Money); }
    public void PayBank1000() { if (GameController.controller.Money >= 1000) GameController.controller.PayBank(1000f); }
}
