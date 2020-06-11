from individual import Individual
from controller import Controller

def setup():
    global controller
    controller = Controller()
    #coins_list = [0.25, 0.25, 0.1, 1, 5, 2, 5, 10, 0.1, 0.1, 0.01, 0.01, 0.01]
    #target = 9.74
    
    #bob = Individual(coins_list, target)
    #mary = Individual(coins_list, target)
    #bob.debug_print()
    #mary.debug_print()
    #print(bob.fitness())
    #print(mary.fitness())
    
    #lil_jimmy = bob.mate_with(mary)
    #lil_jimmy.debug_print()
    #lil_jimmy.mutate()
    #lil_jimmy.debug_print()
    #print(lil_jimmy.fitness())
    
    
def draw():
    global controller
    controller.draw()
