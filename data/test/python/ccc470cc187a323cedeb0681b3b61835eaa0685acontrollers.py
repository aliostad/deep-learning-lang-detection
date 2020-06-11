from Repository.CarRepository import CarRepository


class CarController():


    def __init__(self, rep):
        self.__rep=rep


    def filtrare_tip(self, tip):
        rep=CarRepository('cars.txt')
        cars=rep.getAll
        l=[]
        for l in cars:
            if cars[l][2]==tip:
                l.append(cars[l][2])
        return l

    def update(self, nr, m, t, p):
        c=self.__rep.findById(nr)
        if c == None:
            raise ValueError("Nu exista masina")
        self.__rep.update(car(nr, m, t, p))

