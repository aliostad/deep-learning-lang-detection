import cocos
import tilemap as tm
import sheep
import dog
import wolf

class HerdemLevel(object):
    sheep = []
    dogs = []
    threats = []
    map_path = "levels/level0.xml"
    time_limit = 100
    lose_limit = 1

    def __init__(self, controller):
        self.controller = controller
        self.save_target = len(self.sheep)
        return

    def create(self):
        bg = tm.TileMap(self.map_path, self.controller)
        self.controller.scene.add(bg, z = -1)

 
        for s in self.sheep:
            self.controller.sheeps.append(s)
            self.controller.scene.add(s)
        self.controller.total_sheep = len(self.sheep)

        self.controller.dog = []
        for e, d in enumerate(self.dogs):
            self.controller.dog.append(d)
            self.controller.dog[e].player_number = e
            self.controller.scene.add(d)

        for a in self.threats:
            pass

    def won(self):
        if self.controller.saved_sheeps == self.save_target:
            return True
        return False

    def lost(self):
        if self.controller.lost_sheeps >= self.lose_limit:
            return True
        return False


class Level1(HerdemLevel):
    def __init__(self, controller):
        self.map_path = "levels/level1.tmx"

        self.sheep = [sheep.SheepSprite(controller, pos = (600, 600), image_file = "sheep"),
                      sheep.SheepSprite(controller, pos = (700, 700), image_file = "sheep"),
                      sheep.SheepSprite(controller, pos = (900, 700), image_file = "sheep"),
                     ]

        self.dogs = [dog.DogSprite(controller, pos = (470, 170), image_file = "dog"),]
        super(Level1, self).__init__(controller)
        self.save_target = 3

        self.name = "The Meadow"

        return


class Level2(HerdemLevel):
    def __init__(self, controller):
        self.map_path = "levels/level1.tmx"

        self.sheep = [sheep.SheepSprite(controller, pos = (600, 600), image_file = "sheep"),
                      sheep.SheepSprite(controller, pos = (700, 700), image_file = "sheep"),
                      sheep.SheepSprite(controller, pos = (900, 700), image_file = "sheep"),
                     ]

        self.dogs = [dog.DogSprite(controller, pos = (470, 170), image_file = "dog"),
                     dog.DogSprite(controller, pos = (470, 370), image_file = "dog2"),
                    ]

        super(Level2, self).__init__(controller)
        self.name = "Second Go"

        return
