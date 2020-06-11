from tuf.libtuf import *
import shutil

#this is all standard from the documentation
generate_and_write_rsa_keypair("./key", 2048, "password")

pubKey = import_rsa_publickey_from_file("./key.pub")
privKey = import_rsa_privatekey_from_file("./key", "password")

repository = create_new_repository("./repository")

repository.root.add_key(pubKey)
repository.targets.add_key(pubKey)
repository.release.add_key(pubKey)
repository.timestamp.add_key(pubKey)

repository.root.threshold = 1
repository.root.load_signing_key(privKey)
repository.targets.load_signing_key(privKey)
repository.release.load_signing_key(privKey)
repository.timestamp.load_signing_key(privKey)

repository.targets.delegate("unclaimed", [pubKey], [])
repository.targets.unclaimed.load_signing_key(privKey)


y = 0
while y < 4096:
    prefix = []
    for k in range(y, y + 4):
        a = hex(k)
        pre = ''
        if len(a[2:]) == 1:
            pre = "00" + a[2:]
        elif len(a[2:]) == 2:
            pre = "0" + a[2:]
        else:
            pre = a[2:]
        prefix.append(pre)

    delName = hex(y)
    if len(delName[2:]) == 1:
        delName = "00" + delName[2:]
    elif len(delName[2:]) == 2:
        delName = "0" + delName[2:]
    else:
        delName = delName[2:]

    repository.targets.unclaimed.delegate(delName, [pubKey], [], 1, None, prefix)
    tmp = getattr(repository.targets.unclaimed, delName)
    tmp.load_signing_key(privKey)

    if y % 512 == 0:
        print y, "/ 4096 complete"
    y += 4
print "4096 / 4096 complete"

print "writing repository data"
repository.write()

