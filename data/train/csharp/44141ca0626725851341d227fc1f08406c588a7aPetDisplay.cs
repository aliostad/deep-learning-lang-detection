﻿﻿﻿
using com.u3d.bases.controller;
using com.u3d.bases.display.controler;
using UnityEngine;

/* *******************************************************
 * author :  qi luo
 * email  :  408176274@qq.com  
 * history:  created by qi luo   2014/03/05 01:58:24 
 * function: 宠物显示
 * *******************************************************/

namespace com.u3d.bases.display.character
{
    public class PetDisplay : ActionDisplay
    {
        override protected string SortingLayer { get { return "Player"; } }

        /**添加控制脚本**/
        override protected void AddScript(GameObject go)
        {
            //增加控制中心控制脚本
            if (go.GetComponent<ActionControler>() != null) return;
            Controller = go.AddComponent<ActionControler>();
            Controller.Me = this;
            Controller.Me.Animator = Controller.Me.GoCloth.GetComponent<Animator>();
            //增加状态控制脚本
            var statuController = go.AddComponent<StatuControllerBase>();
            Controller.StatuController = statuController;
            statuController.MeControler = Controller as ActionControler;

            //增加技能控制脚本
            Controller.SkillController = go.AddComponent<SkillController>();
            Controller.SkillController.MeController = Controller as ActionControler;

            //增加攻击控制脚本
            var attackController = go.AddComponent<PetAttackController>();
            attackController.MeController = Controller as ActionControler;
            Controller.AttackController = attackController;

            //增加受击控制脚本
            var beAttackedController = go.AddComponent<BeAttackedControllerBase>();
            beAttackedController.meController = Controller as ActionControler;
            Controller.BeAttackedController = beAttackedController;

            //增加动画事件控制脚本
            Controller.AnimationEventController = GoCloth.GetComponent<AnimationEventController>() ?? GoCloth.AddComponent<AnimationEventController>();
            Controller.AnimationEventController.skillController = Controller.SkillController;

            //增加移动控制脚本
            var monsterMoveController = go.AddComponent<MoveControllerBase>();
            monsterMoveController.AnimationEventController = Controller.AnimationEventController;
            monsterMoveController.MeController = Controller as ActionControler;
            Controller.MoveController = monsterMoveController;
            monsterMoveController.AnimationParameter = Controller.AnimationParameter;

            //增加AI控制脚本
            var aiController = go.AddComponent<PetAiController>();
            aiController.MeController = Controller as ActionControler;
            Controller.AiController = aiController;

            //增加天赋技能处理脚本
            var talentSkillController = go.AddComponent<PetTalentSkillController>();
            talentSkillController.MeController = Controller as ActionControler;
            Controller.TalentSkillController = talentSkillController;
        }

         
    }
}