def main():
  # get controller names
  joints = ["shoulder_pan_controller",
            "shoulder_lift_controller",
            "upper_arm_roll_controller",
            "elbow_flex_controller",
            "forearm_roll_controller",
            "wrist_flex_controller",
            "wrist_roll_controller"]
  r_ctrl=[]
  l_ctrl = []
  for joint in joints:
    r_ctrl.append("r_"+joint);
    l_ctrl.append("l_"+joint);
  ctrl = r_ctrl + l_ctrl

  beginning = '<node pkg="pr2_controller_manager" type="spawner" args="'
  middle='" name="my_controller_spawner_'
  end = '" />'
  for controller in ctrl:
    print beginning + controller +middle + controller+ end

main()
