function addController(puppet, vel){//puppet is the player that is controlled!
	console.log("Controller initialized");
	var controller = {
		puppet:puppet,
	}
	controller.updateKeyboard = function(){
		if(!controller.puppet.isAttacking()){
			moved = false
			if(key.isDown.right && !key.isDown.left){
				moved = true;
				
				controller.puppet.rect.x += vel;
				controller.puppet.setDirection("Right");
				if (!controller.puppet.rect.touching(walls))//detect if controller.puppet will collide with a wall
					controller.puppet.moveEntity(vel, 0, 0);
				else
					controller.puppet.rect.x -= vel;
			}
			if(key.isDown.left && !key.isDown.right){
				moved = true;
				
				controller.puppet.rect.x -= vel;
				controller.puppet.setDirection("Left");
				if (!controller.puppet.rect.touching(walls))
					controller.puppet.moveEntity(-vel, 0, 0);
				else
					controller.puppet.rect.x += vel;
			}
			if(key.isDown.up && !key.isDown.down){
				moved = true;
				
				controller.puppet.rect.z -= vel;
				if (!controller.puppet.rect.touching(walls))
					controller.puppet.moveEntity(0, 0, -vel);
				else
					controller.puppet.rect.z += vel;
			}
			if(key.isDown.down && !key.isDown.up){
				moved = true;
			
				controller.puppet.rect.z += vel;
				if (!controller.puppet.rect.touching(walls))
					controller.puppet.moveEntity(0, 0, vel);
				else
					controller.puppet.rect.z -= vel;
			}
			
			if (moved) {
				if (controller.puppet.state != "jump")
					controller.puppet.updateState("walk");
			}
			else
			{
				if (controller.puppet.state != "jump")
					controller.puppet.updateState("standing");
			}
		}
	};
	
	controller.onJump = function() {
		if(controller.puppet.state=="standing" || controller.puppet.state == "walk")
		{
			controller.puppet.fallspeed = -15;
			controller.puppet.updateState("jump");
		}
	};
	
	controller.onAttack = function() {
		controller.puppet.executeAttack("punch");
	}
	
	controller.toggleDebug = function() {
		debug = !debug;
	}
	
	key.onPress.x.push(controller.onJump);
	key.onPress.z.push(controller.onAttack);
	key.onPress.t.push(controller.toggleDebug);
	
	return controller;
}