from tuf.libtuf import *
import hashlib
import threading
import time

#see documentation
repository = load_repository("./repository/")

pubKey = import_rsa_publickey_from_file("./key.pub")
privKey = import_rsa_privatekey_from_file("./key", "password")

targets = repository.get_filepaths_in_directory("./repository/targets/1024/",
                                                recursive_walk=True, followlinks=True)

repository.release.add_key(pubKey)
repository.timestamp.add_key(pubKey)
repository.release.load_signing_key(privKey)
repository.timestamp.load_signing_key(privKey)

class threadTargets(threading.Thread):
    def __init__(self, target, privKey):
        threading.Thread.__init__(self)
        self.target = target
        self.privKey = privKey

    def run(self):
        t = hashlib.sha256()
            
        s = self.target[0:21] + self.target[26:]
            
        t.update(s)
        y = t.hexdigest()

        num = int(y[0:3], 16)
        mod = num % 4
        num -= mod
        y = hex(num)
        y = y[2:]

        if len(y) == 1:
            y = "00" + y
        elif len(y) == 2:
            y = "0" + y
            
        tmp = getattr(repository.targets.unclaimed, y)
        tmp.add_target(self.target)
        tmp.load_signing_key(self.privKey)

for target in targets:
    test = threadTargets(target, privKey)
    test.start()

while threading.activeCount() > 1:
    time.sleep(3)

print "write 1"
repository.write()
