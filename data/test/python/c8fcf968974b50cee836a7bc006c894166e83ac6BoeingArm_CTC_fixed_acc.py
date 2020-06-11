# -*- coding: utf-8 -*-
"""
Created on Sun Aug 14 13:27:30 2016

@author: agirard
"""

from AlexRobotics.dynamic import CustomManipulator    as CM

from AlexRobotics.control  import RminComputedTorque   as RminCTC

import numpy as np

R = CM.BoeingArm()

R.mc0 = 1.0

    
x0 = np.array([0,0,0,0,0,0])
    
# Assign controller
CTC_controller     = RminCTC.RminComputedTorqueController( R )
R.ctl              = CTC_controller.manual_acc_ctl

CTC_controller.w0           = 0.5
CTC_controller.zeta         = 0.7
CTC_controller.n_gears      = 2

CTC_controller.ddq_manual_setpoint = np.array([ 1,0,0])


R.plotAnimation( x0 ) 

R.Sim.plot_CL('u')