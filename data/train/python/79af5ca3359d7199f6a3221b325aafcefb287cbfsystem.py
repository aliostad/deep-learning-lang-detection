import cpu
import memory
import video


class System():
    """Represents a computer system."""

    def __init__(self):
        """Creates and initializes the system components."""
        self._cpu = cpu.Cpu()
        self._memory_controller = memory.MemoryController()
        self._video_controller = video.VideoController()

    def power_on(self):
        """Powers on the system components."""
        print("System.power_on()")
        self._cpu.power_on()
        self._memory_controller.power_on()
        self._video_controller.power_on()
