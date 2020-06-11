import data_helper
import keras
import sys
import numpy as np
import defs

print 'usage: test.py <filename>'
if len(sys.argv) < 2:
  exit(0)

file_name = sys.argv[1]

x = np.array(data_helper.turn_file_to_vectors(file_name, file_vector_size=defs.file_characters_truncation_limit
                                              , breakup=False))
model = keras.models.load_model('./save_tmp.h5')
y = model.predict(x)

result = model.predict_proba(x)

print(y)

for i in range(0, len(defs.langs)):
  print "{} - {}:     \t\t{}%".format(' ' if (y[0][i] < 0.5) else '*', defs.langs[i], round(100 * y[0][i]), 4)