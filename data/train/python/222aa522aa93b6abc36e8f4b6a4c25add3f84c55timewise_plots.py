# coding: utf-8
from data_access.dropbox_repositories import PositionRadiansDropboxRepository, PositionMetersDropboxRepository, SpeedRadiansDropboxRepository, SpeedMetersDropboxRepository

from data_access.timewise_repositories import PositionRadiansTimewiseRepository, SpeedRadiansTimewiseRepository, TorqueTimewiseRepository, AccelerationTimewiseRepository, PositionMetersTimewiseRepository, SpeedMetersTimewiseRepository
from gui.data_plotting.plot_base_classes import RealTimePlot, ComparablePlot

class PositionRadiansTimewisePlot(RealTimePlot):
    def __init__(self, order=0, number_of_plots=4):
        self.data_repository = PositionRadiansTimewiseRepository()
        super(PositionRadiansTimewisePlot, self).__init__(self.data_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Position',
            x_label=u'Temps (s)',
            y_label=u'Position (rad)')


class PositionRadiansTimewiseComparablePlot(ComparablePlot):
    def __init__(self, order=0, number_of_plots=4):
        self.data_repository = PositionRadiansTimewiseRepository()
        self.dropbox_repository = PositionRadiansDropboxRepository()
        super(PositionRadiansTimewiseComparablePlot, self).__init__(self.data_repository, self.dropbox_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Position',
            x_label=u'Temps (s)',
            y_label=u'Position (rad)')


class PositionMetersTimewisePlot(RealTimePlot):
    def __init__(self, order=0, number_of_plots=4):
        self.data_repository = PositionMetersTimewiseRepository()
        super(PositionMetersTimewisePlot, self).__init__(self.data_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Position',
            x_label=u'Temps (s)',
            y_label=u'Position (m)')


class PositionMetersTimewiseComparablePlot(ComparablePlot):
    def __init__(self, order=0, number_of_plots=4):
        self.data_repository = PositionMetersTimewiseRepository()
        self.dropbox_repository = PositionMetersDropboxRepository()
        super(PositionMetersTimewiseComparablePlot, self).__init__(self.data_repository, self.dropbox_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Position',
            x_label=u'Temps (s)',
            y_label=u'Position (m)')


class SpeedRadiansTimewisePlot(RealTimePlot):
    def __init__(self, order=1, number_of_plots=4):
        self.data_repository = SpeedRadiansTimewiseRepository()
        super(SpeedRadiansTimewisePlot, self).__init__(self.data_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Vitesse',
            x_label=u'Temps (s)'
            , y_label=u'Vitesse (rad / s)')


class SpeedRadiansTimewiseComparablePlot(ComparablePlot):
    def __init__(self, order=0, number_of_plots=4):
        self.data_repository = SpeedRadiansTimewiseRepository()
        self.dropbox_repository = SpeedRadiansDropboxRepository()
        super(SpeedRadiansTimewiseComparablePlot, self).__init__(self.data_repository, self.dropbox_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Vitesse',
            x_label=u'Temps (s)',
            y_label=u'Vitesse (rad / s)')


class SpeedMetersTimewisePlot(RealTimePlot):
    def __init__(self, order=1, number_of_plots=4):
        self.data_repository = SpeedMetersTimewiseRepository()
        super(SpeedMetersTimewisePlot, self).__init__(self.data_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Vitesse',
            x_label=u'Temps (s)'
            , y_label=u'Vitesse (km / h)')


class SpeedMetersTimewiseComparablePlot(ComparablePlot):
    def __init__(self, order=0, number_of_plots=4):
        self.data_repository = SpeedMetersTimewiseRepository()
        self.dropbox_repository = SpeedMetersDropboxRepository()
        super(SpeedMetersTimewiseComparablePlot, self).__init__(self.data_repository, self.dropbox_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Vitesse',
            x_label=u'Temps (s)',
            y_label=u'Vitesse (km / h)')


class AccelerationTimewisePlot(RealTimePlot):
    def __init__(self, order=2, number_of_plots=4):
        self.data_repository = AccelerationTimewiseRepository()
        super(AccelerationTimewisePlot, self).__init__(self.data_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots),
            title=u'Accélération',
            x_label=u'Temps (s)'
            , y_label=u'Accélération (rad / s\xb2)')


class TorqueTimewisePlot(RealTimePlot):
    def __init__(self, order=3, number_of_plots=4):
        self.data_repository = TorqueTimewiseRepository()
        super(TorqueTimewisePlot, self).__init__(self.data_repository,
            subplot_code=self._calculate_subplot_code(order, number_of_plots)
            , title=u'Torque',
            x_label=u'Temps (s)',
            y_label=u'Torque (Nm)')