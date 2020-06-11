package com.csust.listener;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import com.csust.views.PersonManageFrame;

public class PersonManageFrame_ActionListener implements ActionListener {

	private PersonManageFrame personManageFrame;

	public PersonManageFrame_ActionListener(PersonManageFrame personManageFrame) {
		this.personManageFrame = personManageFrame;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		String command = e.getActionCommand();
		if(command.equals("add")){
			personManageFrame.btn_addPerformed();
		}else if(command.equals("delete")){
			personManageFrame.btn_deletePerformed();
		}else if(command.equals("daochu")){
			personManageFrame.btn_DaochuPerformed();
		}
	}

}
