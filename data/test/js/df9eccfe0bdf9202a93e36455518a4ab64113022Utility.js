function initController(address) {
  controller.setGraffikModeEnable(true);
  controller.setJoystickMode(false);
  controller.setWatchdogEnable(false);
  controller.enableCamera(true);

  controller.setMotorEnable(1, true);
  controller.setMotorEnable(2, true);
  controller.setMotorEnable(3, true);

  controller.setMicroStepValue(1, 4);
  controller.setMicroStepValue(2, 4);
  controller.setMicroStepValue(3, 4);

  controller.setEasingMode(1, 2);
  controller.setEasingMode(2, 2);
  controller.setEasingMode(3, 2);

  controller.setProgramMode(1);
  controller.setFocusWithShutter(true);
  for(var i = 1; i <= 3; ++i)
    controller.setMotorAcceleration(i, 25000.0);
}
