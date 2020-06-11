import subprocess


class SshConnection:



    def __init__(self, ip):
        self.controller = subprocess.Popen("ssh root@192.168.0.104", shell=True, close_fds = True, stdin=subprocess.PIPE)

        self.controller.stdin.write("/root/development/projects/trackedRobot/movement/movement_console.py")
        self.controller.stdin.write('\n')
        self.controller.stdin.flush()


    def sendKeysStatus(self, keysStatus):
        self.controller.stdin.write(keysStatus)
        self.controller.stdin.flush()

