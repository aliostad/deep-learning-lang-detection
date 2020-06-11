class BrokerVolumeTooBigError(ValueError):
    pass

class Broker(object):

    def __init__(self, name, price):
        self.__name = name
        self.__price = price
        self.__total_volume = []

    def __calculate_cost(self, volume):
        if volume > 100:
            raise BrokerVolumeTooBigError("Order volume is bigger then 100")
        commission_policy_params = {'volume': volume}
        commission = (1 + self._commission_policy(commission_policy_params))
        final_price = self.__price * commission
        return final_price * volume

    def _commission_policy(self, params):
        raise NotImplementedError

    def quote(self, volume):
        return self.__calculate_cost(volume)

    def execute(self, volume):
        self.__total_volume.append(volume)
        return self.__calculate_cost(volume)

    @staticmethod
    def max_volume():
        return 100

    @property
    def total_volume(self):
        return sum(self.__total_volume)

    @property
    def name(self):
        return self.__name


class BrokerWithConstantComission(Broker):

    def __init__(self, name, price):
        super(self.__class__, self).__init__(name, price)

    def _commission_policy(self, params):
        return 0.05

class BrokerWithVolumeBasedCommission(Broker):

    def __init__(self, name, price):
        super(self.__class__, self).__init__(name, price)

    def _commission_policy(self, params):
        volume = params['volume']
        if volume <= 40:
            return 0.03
        elif volume <= 80:
            return 0.025
        return 0.02


class BrokerProvider(object):

    @staticmethod
    def provide(name):
        if name == "Broker1":
            return BrokerWithConstantComission(name, 1.49)
        if name == "Broker2":
            return BrokerWithVolumeBasedCommission(name, 1.52)
        assert 0, "Unknown broker: " + name

    @staticmethod
    def get_available_brokers_id():
        return ["Broker1", "Broker2"]
