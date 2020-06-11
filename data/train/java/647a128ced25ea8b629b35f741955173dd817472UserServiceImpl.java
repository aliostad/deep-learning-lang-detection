package com.vstar.serivce.impl;

import com.vstar.dao.process.propertyUpload.RegistrationProcess;
import com.vstar.serivce.UserService;

public class UserServiceImpl implements UserService {
	private RegistrationProcess registrationProcess;

	@Override
	public String findUserProfileInfo() {
		/*return registrationProcess
				.getUserProfileInfo();*/
	  return null;
	}

  public RegistrationProcess getRegistrationProcess()
  {
    return registrationProcess;
  }

  public void setRegistrationProcess(RegistrationProcess registrationProcess)
  {
    this.registrationProcess = registrationProcess;
  }
	
}
