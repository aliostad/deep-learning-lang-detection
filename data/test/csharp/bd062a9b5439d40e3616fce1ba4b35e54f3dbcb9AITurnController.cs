using UnityEngine;
using System.Collections;

public class AITurnController : TurnController {

	public override StageController StageToController(Stage stage){
		StageController stageController = null;
		switch(stage){
		case Stage.ALLOCK :{
			stageController =  new AIAllockStageController();
			break;
		}
		case Stage.ATTACK:{
			stageController =  new AIAttackStageController();
			break;
		}
		case Stage.MOVE:{
			stageController =  new AIMoveStageController();
			break;
		}
		default : return null;
		}
		stageController.turnController = this;
		return stageController;
	}


	public override void OnTurnStart(){
		if(Player.Territories.Count ==0){
			EndTurn();
		}
	}
}
