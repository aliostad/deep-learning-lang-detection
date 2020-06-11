from pl.edu.agh.iwum.pendulum.controllers.classifier.ClassifierController import ClassifierController
from pl.edu.agh.iwum.pendulum.controllers.classifierBlind.ClassifierRegressionController import ClassifierRegressionController
from pl.edu.agh.iwum.pendulum.controllers.reinforced.ReinforcedController import ReinforcedController


class ControllersUtil(object):
    REINFORCED_CONTROLLER = ReinforcedController.NAME
    CLASSIFIER_CONTROLLER = ClassifierController.NAME
    CLASSIFIER_REGRESSION_CONTROLLER = ClassifierRegressionController.NAME

    REGISTERED_CONTROLLERS = {
        REINFORCED_CONTROLLER: ReinforcedController,
        CLASSIFIER_CONTROLLER: ClassifierController,
        CLASSIFIER_REGRESSION_CONTROLLER: ClassifierRegressionController
    }

    @staticmethod
    def registered_controllers():
        return ControllersUtil.REGISTERED_CONTROLLERS.keys()

    @staticmethod
    def get_controller(name):
        return ControllersUtil.REGISTERED_CONTROLLERS[name]

    @staticmethod
    def default_controller():
        return ControllersUtil.CLASSIFIER_CONTROLLER