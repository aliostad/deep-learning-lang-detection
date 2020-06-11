# Observe a list of counters to watch for growth

from dictdiff import dict_diff
from store import save,recall


# Save the last group of counters
def previous_counts(collection, text):
    save(collection+'/past',text)


# Save the current group of counters
def next_counts(collection, text):
    save(collection+'/current',text)


# Find all changes
def changes(collection):
    t1 = recall(collection+'/past')
    t2 = recall(collection+'/current')
    return dict_diff(t2,t1)


# Accept the current changes
def accept(collection):
    t = recall(collection+'/current')
    save(collection+'/past',t)
