import pickle
import os, sys

import dispatch

SAVE_PATH=os.path.expanduser('~/.tvsync.d/filesprocessed')
save = open(SAVE_PATH, 'r')
processed=pickle.load(save)
save.close()

for f in sys.argv[1:]:
    if f in processed:
        print 'Already processed ' + f
        continue
    path, filename = os.path.split(f)
    dest = os.path.join('/tmp', filename)
    print "Copying %s to %s" % (f, dest)
    #shutil.copyfile(f, dest)
    dispatch.dispatch(dest)
    processed.append(f)

    save = open(SAVE_PATH, 'w')
    pickle.dump(processed, save)
    save.close()

