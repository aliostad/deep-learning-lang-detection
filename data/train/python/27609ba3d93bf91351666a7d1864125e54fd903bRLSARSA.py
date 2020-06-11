import random
class RLSARSA:
    def __init__(self, alpha):
        self.alpha = alpha
        self.Q = {}

    def touch(self, observation, action):
        key = (observation, action)
        #print "Key:", key
        if not key in self.Q:
            self.Q[key] = 0 #assign 0 as the initial value

    def update(self, lastObservation, lastAction, diffQ):
        key = (lastObservation, lastAction)
        self.Q[key] = self.Q[key] + self.alpha*(diffQ)
    def getQ(self, observation, action):
        self.touch(observation, action)
        key = (observation, action)
        return self.Q[key]
    
if __name__ == "__main__":
    
    controller = RLSARSA(0.5, 0, 0.8, (-1, 1))
    print controller.start((0, 0, 1))
    print controller.Q
    print controller.step(-1, (0, 0, 0))
    print controller.Q
    print controller.step(-1, (0, 0, 0))
    print controller.Q
    print controller.step(-1, (0, 0, 0))
    print controller.Q
    print controller.step(-1, (0, 0, 0))
    print controller.Q
    print controller.step(-1, (0, 0, 0))
    print controller.Q
    print controller.end(1)
    print controller.Q
    import pickle
    output = open('data.pkl', 'wb')
    pickle.dump(controller, output)
    output.close()
    input = open('data.pkl', 'rb')
    ctrl2 = pickle.load(input)
    print "after load"
    print ctrl2.Q
    
