from controller import Controller

class SampleCurvatureController(Controller):
    pass

class SampleChangeController(Controller):
    
    def desired_curvature(self, position, kappa, sign_omega, *args, **kwargs):
        return kappa, -sign_omega


class DirectionDecisionController:
    '''
    Sample master controller that decides when other controllers should be used    
    '''
    def __init__(self,  movement_controller, change_controller, x_change=25):
        self.movement_controller = movement_controller
        self.change_controller = change_controller
        # what is the x when we should change direction
        self.x_change= x_change
        self.recently_passed_change = False
    
    def control(self, position, kappa, sign_omega, *args, **kwargs):
        x,y,_ = position
        if abs(x) > self.x_change-0.2 and abs(x) <  self.x_change+0.2:
            if not self.recently_passed_change:
                self.recently_passed_change = True
                # change controller should least only for one quantum of time - change the sign
                return self.change_controller.control((x,y), kappa, sign_omega, *args, **kwargs)
        else:
            self.recently_passed_change = False
        return self.movement_controller.control((x,y), kappa, sign_omega, *args, **kwargs)
    
if __name__ == '__main__':
    from skier import Skier
    from visual import vector
    from math import pi
    import skier_with_air_resistance_force
    from simulation import SkierSimulation
    from hop_turn_controller import HopTurningController,StraightGoingController,RightTurnController,LeftTurnController
    import pylab
    mi = 0.05 #waxed skis - typical value
    
    alfa = pi/6
    roh = 1.32 #kg*(m^(-3))
    
    m = 60 #kg
    C = 0.6  #drag coefficient, typical values (0.4 - 1)
    
    A= 0.2 # m^2- medium position between upright and tucked

    k2 = 0.5 * C * roh * A

    kappa = 1/20.0
    k1 = 0.05 #imaginary value
    x0 = vector(0,0)
    v0 = vector(0,19)   #'''sqrt(2000)'''
    slalom = [(0,0)]
    B = 4
    solver=skier_with_air_resistance_force.solver
    kappa_controller_A = DirectionDecisionController(movement_controller=SampleCurvatureController(),
                                                  change_controller=SampleChangeController())
    kappa_controller_B = HopTurningController(slalom=slalom, right_turning_controller=RightTurnController(kappa),
                                    left_turning_controller=LeftTurnController(kappa),
                                    straight_controller=StraightGoingController(), 
                                    kappa=kappa, boundary_val=0.2)
    racer = Skier(mi, alfa, k1, k2, B, m, x0, v0, kappa, slalom,solver, kappa_controller_A, color="red")
    racer2 = Skier(mi, alfa, k1, k2, B, m, x0, v0, kappa, slalom, solver, kappa_controller_B, color="yellow")

    sim = SkierSimulation(distance=200, interval=0.01, time_zoom=100)
    sim.add_racer(racer)
    sim.add_racer(racer2)
    sim.run()
    
    pylab.plot(sim.timeline,racer.sign_omegas, 
           sim.timeline,racer2.sign_omegas,)
    
    pylab.legend(('skier A', 'skier B'), loc='lower right')
    pylab.xlabel("time in seconds")
    pylab.ylabel("signum of omega")
    pylab.grid(True)
    pylab.show()
    
    pylab.plot(sim.timeline,racer.kappas, 
           sim.timeline,racer2.kappas,)
    
    pylab.legend(('skier A', 'skier B'), loc='lower right')
    pylab.xlabel("time in seconds")
    pylab.ylabel("kappa in 1/meters")
    pylab.grid(True)
    pylab.show()