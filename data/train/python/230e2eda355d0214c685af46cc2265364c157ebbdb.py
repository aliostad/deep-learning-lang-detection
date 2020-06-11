"""
Interface to save raw key frames and raw packets.
"""
import logging

__all__ = ['save_key_frame', 'save_packet']

log = logging.getLogger(__name__)

def save_key_frame(frame, key_frame_id):
    """
    Save a raw key frame with id.

    @param frame: frame to save.
    @type frame: C{string}.
    @param key_frame_id: key frame id.
    @type key_frame_id: C{string}.
    """
    Database().save_key_frame(frame, key_frame_id)

def save_packet(packet):
    """
    Save a raw packet.

    @param packet: packet to save.
    @type packet: C{string}.
    """
    Database().save_packet(packet)

class Database(object):
    """Interface to save key frames and packets to file system."""
    packet_id = 0

    @classmethod
    def save_key_frame(cls, frame, key_frame_id):
        """save raw key frame to .kframe file."""
        with open('{0}.kframe'.format(key_frame_id), 'w') as _file:
            _file.write(frame)

    @classmethod
    def save_packet(cls, packet):
        """save raw packet to .packet file."""
        with open('{0:0>5d}.packet'.format(cls.packet_id), 'w') as _file:
            _file.write(packet.raw)
        cls.packet_id += 1

