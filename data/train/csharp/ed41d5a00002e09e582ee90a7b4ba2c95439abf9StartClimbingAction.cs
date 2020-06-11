using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

[CreateAssetMenu(menuName = "Prototype/CharactersActions/StartClimbingAction")]
public class StartClimbingAction : _Action
{


    public override void Execute(CharacterStateController controller)
    {
        StartClimb(controller);
    }

    private void StartClimb(CharacterStateController controller)
    {
        if (controller.m_CharacterController.climbingTop)
        {
            controller.m_CharacterController.climbAnchorTop = controller.m_CharacterController.climbCollider.transform.parent.transform.GetChild(2);
            Debug.Log("Scendo");
            controller.m_CharacterController.startClimbAnimationTop = true;
           // controller.m_CharacterController.CharacterTansform.position = controller.m_CharacterController.climbAnchorTop.position;
        }
        else
        {
            controller.m_CharacterController.climbAnchorBottom = controller.m_CharacterController.climbCollider.transform.parent.transform.GetChild(3);
            Debug.Log("Salgo");
            // controller.m_CharacterController.startClimbAnimationBottom = true;
            //controller.m_CharacterController.CharacterTansform.position = controller.m_CharacterController.climbAnchorBottom.position;
            controller.m_CharacterController.CharacterTansform.DOMove(controller.m_CharacterController.climbAnchorBottom.position, 1f);

        }
    }

}
