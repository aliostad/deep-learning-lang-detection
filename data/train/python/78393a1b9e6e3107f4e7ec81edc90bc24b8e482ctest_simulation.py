from cs143sim.constants import OUTPUT_BUFFER_OCCUPANCY_SCALE_FACTOR
from cs143sim.constants import OUTPUT_FLOW_RATE_SCALE_FACTOR
from cs143sim.constants import OUTPUT_LINK_RATE_SCALE_FACTOR
from cs143sim.simulation import Controller
from test_actors import basic_flow
from test_actors import basic_link


def basic_controller():
    return Controller()


def controller_record_buffer_occupancy():
    controller = basic_controller()
    link = basic_link()
    buffer_occupancies = range(5)
    for buffer_occupancy in buffer_occupancies:
        controller.record_buffer_occupancy(link=link,
                                           buffer_occupancy=buffer_occupancy)
    recorded_buffer_occupancies = [record[1] for record in
                                   controller.buffer_occupancy[link]]
    assert (recorded_buffer_occupancies ==
            [x * OUTPUT_BUFFER_OCCUPANCY_SCALE_FACTOR for x in buffer_occupancies])


def controller_record_flow_rate():
    controller = basic_controller()
    flow = basic_flow()
    packet_sizes = range(5)
    for packet_size in packet_sizes:
        controller.record_flow_rate(flow=flow, packet_size=packet_size)
    recorded_packet_sizes = [record[1] for record in
                             controller.flow_rate[flow]]
    assert (recorded_packet_sizes ==
            [x * OUTPUT_FLOW_RATE_SCALE_FACTOR for x in packet_sizes])


def controller_record_link_rate():
    controller = basic_controller()
    link = basic_link()
    packet_sizes = range(5)
    for packet_size in packet_sizes:
        controller.record_link_rate(link=link, packet_size=packet_size)
    recorded_packet_sizes = [record[1] for record in
                             controller.link_rate[link]]
    assert (recorded_packet_sizes ==
            [x * OUTPUT_LINK_RATE_SCALE_FACTOR for x in packet_sizes])


def controller_record_packet_delay():
    controller = basic_controller()
    flow = basic_flow()
    packet_delays = range(5)
    for packet_delay in packet_delays:
        controller.record_packet_delay(flow=flow, packet_delay=packet_delay)
    recorded_packet_delays = [record[1] for record in
                              controller.packet_delay[flow]]
    assert recorded_packet_delays == packet_delays


def controller_record_packet_loss():
    controller = basic_controller()
    link = basic_link()
    packet_losses = [None] * 5
    for _ in packet_losses:
        controller.record_packet_loss(link=link)
    recorded_packet_losses = [record[1] for record in
                              controller.packet_loss[link]]
    assert recorded_packet_losses == packet_losses


def controller_record_window_size():
    controller = basic_controller()
    flow = basic_flow()
    window_sizes = range(5)
    for window_size in window_sizes:
        controller.record_window_size(flow=flow, window_size=window_size)
    recorded_window_sizes = [record[1] for record in
                             controller.window_size[flow]]
    assert recorded_window_sizes == window_sizes


def controller_run_basic():
    controller = basic_controller()
    controller.run(until=10)


def test_controller():
    controller_run_basic()
    controller_record_buffer_occupancy()
    controller_record_flow_rate()
    controller_record_link_rate()
    controller_record_packet_delay()
    controller_record_packet_loss()
    controller_record_window_size()
