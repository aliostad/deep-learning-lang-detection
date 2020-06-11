from postOffice import MessageBroker
from postOffice import FilingCabinet

from collect import DataCollector
from delivery import AsynchronousDataCarrier
from delivery import SynchronousDataCarrier


def hgw_init():
	"""Instantiate all the needed objects and setups references between them."""

	collector = DataCollector()
	cabinet = FilingCabinet()
	broker = MessageBroker()

	adc = AsynchronousDataCarrier()
	sdc = SynchronousDataCarrier()

	# NOTE: collector -> cabinet <-> broker <-> carrier
	collector.cabinet = cabinet
	cabinet.broker = broker
	broker.cabinet = cabinet
	adc.broker = broker
	broker.carrier = adc
	sdc.cabinet = cabinet 

	return collector, cabinet, broker, adc, sdc

if __name__ == '__main__':
	hgw_init()
