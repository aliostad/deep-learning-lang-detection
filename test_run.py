import data_helper
import keras
import numpy as np
import defs
import precision_recall
import sys
import os
import shutil
import math

def sq_error(vector1, vector2):
  if len(vector1) != len(vector2):
    raise ValueError("vectors not of the same size")
  return sum(math.pow(vector1[i] - vector2[i], 2) for i in range(0, len(vector1)))

def interpret_result(yhati, threshold=0.5):
  """

  :param yhati: result of prediction for a file
  :return: String: the language
  """
  for i in range(0, len(yhati)):
    if yhati[i] > threshold:
      return defs.langs[i]

print 'usage: test_run.py [model file] [folder to copy failed files]'

folderName = None
modelFile = './save_tmp.h5'

if len(sys.argv) > 1:
  modelFile = sys.argv[1]

if len(sys.argv) > 2:
  folderName = sys.argv[2]
  if not os.path.exists(folderName):
    os.mkdir(folderName)


X, Y, Z = data_helper.get_input_and_labels(data_helper.test_root_folder,
                                        defs.file_characters_truncation_limit,
                                        max_files=1000)

x = np.array(X)
model = keras.models.load_model(modelFile)
y_hat = model.predict(x)

success = 0
class_success = {}
class_count = {}
expecteds = []
predicteds = []
sum_sq_error = 0
for i in range(0, len(y_hat)):
  yi = Y[i]
  y_hati = y_hat[i]
  expected = interpret_result(yi)
  predicted = interpret_result(y_hati)
  expecteds.append(yi)
  predicteds.append(y_hati)
  sum_sq_error += sq_error(yi, y_hati)
  if expected not in class_count:
    class_count[expected] = 1
  else:
    class_count[expected] += 1
  if expected == predicted:
    success += 1
    if predicted not in class_success:
      class_success[predicted] = 1
    else:
      class_success[predicted] += 1
  elif folderName is not None:
    fn = os.path.basename(Z[i])
    lang = os.path.basename(os.path.dirname(Z[i]))
    langFolder = os.path.join(folderName, lang)
    if not os.path.exists(langFolder):
      os.mkdir(langFolder)
    shutil.copyfile(Z[i], os.path.join(langFolder, fn))

print "Final result: {}/{} ({})".format(success, len(y_hat), (success * 1.0 / len(y_hat) * 1.0))

prs = precision_recall.calculate_precision_recall(expecteds, predicteds, defs.langs)
for c in prs:
  print "{} - Precision:{} Recall: {}".format(prs[c].get_name(), prs[c].precision(), prs[c].recall())


for key in class_count:
  if key not in class_success:
    class_success[key] = 0
  print "{}:\t\t{}/{} ({})".format(key, class_success[key], class_count[key], class_success[key] * 1.0 / class_count[key] * 1.0)

print "Sum of Squared Error: {}".format(sum_sq_error)