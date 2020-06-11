from pyheating import HeatController, Boiler, TRV
import pytest


@pytest.fixture
def controller():
    return HeatController()


def test_create_basic_heat_controller(controller):
    assert controller._boiler is not None


def test_pass_boiler_as_param_on_init():
    my_boiler = Boiler()
    ctrl = HeatController(boiler=my_boiler)
    assert ctrl._boiler is my_boiler


def test_controller_can_turn_on_and_off_the_boiler(controller):
    assert Boiler.OFF == controller.get_boiler_status()

    controller.turn_boiler_on()

    assert Boiler.ON == controller.get_boiler_status()

    controller.turn_boiler_off()

    assert Boiler.OFF == controller.get_boiler_status()


def test_controller_starts_with_no_trv_units_attached(controller):
    assert len(controller.trv_units) == 0


def test_controller_add_trv(controller):
    controller.add_trv(TRV())
    assert 1 == len(controller.trv_units)


def test_controller_remove_trv(controller):
    u1 = TRV()
    u2 = TRV()
    u3 = TRV()
    controller.add_trv(u1)
    controller.add_trv(u2)
    controller.add_trv(u3)
    controller.remove_trv(u2)
    assert set([u1, u3]) == controller.trv_units


def test_controller_cannot_add_the_same_trv_unit_twice(controller):
    unit = TRV()
    assert controller.trv_units == set()
    controller.add_trv(unit)
    controller.add_trv(unit)
    assert controller.trv_units == set([unit])


def test_trv_without_name_gets_name_assigned_when_added_to_controller(
        controller):
    trv = TRV()
    assert trv.name is None

    controller.add_trv(trv)

    assert trv.name == 'TRV #1'

    trv_2 = TRV('Living room')
    controller.add_trv(trv_2)

    assert trv_2.name == 'Living room'

    trv_3 = TRV()
    controller.add_trv(trv_3)

    assert trv_3.name == 'TRV #3'


def test_controller_can_retrieve_a_trv_unit_by_its_name(controller):
    trv_1 = TRV('TRV One')
    trv_2 = TRV('TRV Two')
    trv_3 = TRV('TRV Three')

    controller.add_trv(trv_1)
    controller.add_trv(trv_2)
    controller.add_trv(trv_3)

    returned_trv_2 = controller.get_trv('TRV Two')

    assert returned_trv_2 is trv_2


def test_controller_does_not_mess_up_with_trv_sequence_ids(controller):
    trv_1 = TRV()
    trv_2 = TRV()

    controller.add_trv(trv_1)
    controller.add_trv(trv_2)

    controller.remove_trv(trv_2)

    trv_3 = TRV()

    controller.add_trv(trv_3)

    assert trv_3.name == 'TRV #3'
