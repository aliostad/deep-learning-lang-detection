import Termin

class Terminkalender:
    
    def __init__(self, repository, besitzer):
        self.__repository = repository
        self.besitzer = besitzer

    def new_termin(self, datum, dauer_in_minuten, bezeichnung):
        termin = Termin.Termin(self.besitzer, datum, dauer_in_minuten, bezeichnung)
        self.__repository.speichere(termin)
        return termin
    
    def hat_termin(self, termin):
        return self.__repository.hat_termin(termin)

    def akzeptierte_termine(self):
        return self.termine(False)
    
    def termine(self, zeige_auch_abgelehnte):
        return self.__repository.termine(self.besitzer, zeige_auch_abgelehnte)


    def alle_termine(self):
        return self.termine(True)