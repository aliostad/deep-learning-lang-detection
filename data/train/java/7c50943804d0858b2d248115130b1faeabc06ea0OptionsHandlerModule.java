/**
* Copyright 2012 nabla
*
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*
*/
package com.nabla.dc.server.handler.options;

import com.nabla.wapp.server.basic.handler.AddRoleHandler;
import com.nabla.wapp.server.basic.handler.AddUserHandler;
import com.nabla.wapp.server.basic.handler.ChangeUserPasswordHandler;
import com.nabla.wapp.server.basic.handler.FetchRoleDefinitionHandler;
import com.nabla.wapp.server.basic.handler.FetchRoleListHandler;
import com.nabla.wapp.server.basic.handler.FetchRoleNameHandler;
import com.nabla.wapp.server.basic.handler.FetchUserDefinitionHandler;
import com.nabla.wapp.server.basic.handler.FetchUserListHandler;
import com.nabla.wapp.server.basic.handler.FetchUserNameHandler;
import com.nabla.wapp.server.basic.handler.RemoveRoleHandler;
import com.nabla.wapp.server.basic.handler.RemoveUserHandler;
import com.nabla.wapp.server.basic.handler.RestoreUserHandler;
import com.nabla.wapp.server.basic.handler.UpdateRoleDefinitionHandler;
import com.nabla.wapp.server.basic.handler.UpdateRoleHandler;
import com.nabla.wapp.server.basic.handler.UpdateUserDefinitionHandler;
import com.nabla.wapp.server.basic.handler.UpdateUserHandler;
import com.nabla.wapp.server.dispatch.AbstractHandlerSubModule;


public class OptionsHandlerModule extends AbstractHandlerSubModule {

	@Override
	protected void configure() {
		bindHandler(FetchRoleNameHandler.class);

		bindHandler(FetchRoleListHandler.class);
		bindHandler(AddRoleHandler.class);
		bindHandler(UpdateRoleHandler.class);
		bindHandler(RemoveRoleHandler.class);
		bindHandler(FetchRoleDefinitionHandler.class);
		bindHandler(UpdateRoleDefinitionHandler.class);

		bindHandler(FetchUserListHandler.class);
		bindHandler(AddUserHandler.class);
		bindHandler(CloneUserHandler.class);
		bindHandler(UpdateUserHandler.class);
		bindHandler(RemoveUserHandler.class);
		bindHandler(RestoreUserHandler.class);
		bindHandler(FetchUserNameHandler.class);
		bindHandler(FetchUserDefinitionHandler.class);
		bindHandler(UpdateUserDefinitionHandler.class);

		bindHandler(ChangeUserPasswordHandler.class);
	}

}
