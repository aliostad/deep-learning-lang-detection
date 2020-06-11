from __future__ import unicode_literals
from flask import Flask, jsonify, request, send_from_directory
import logging
from logging import FileHandler
import time
import data_helper
import keras
import numpy as np
import os
import codecs
import random
import defs
import sys

t = time.time()
app = Flask(__name__)
application = app
model = None
modelFile = './save_tmp.h5'
try:
  if len(sys.argv) > 1:
    modelFile = sys.argv[1]
  file_handler = FileHandler("lang_detection.log", "a")
  file_handler.setLevel(logging.WARNING)
  app.logger.addHandler(file_handler)
  model = keras.models.load_model(modelFile)
  if __name__ == '__main__':
    print("Took {}".format(time.time() - t))
except Exception as e:
  print e.message

@app.route('/', methods=['GET'])
def browse_default():
  try:
    return send_from_directory('ui', 'index.html')
  except Exception as e:
    print e.message
    return e.message

@app.route('/<path:path>', methods=['GET'])
def staticx(path):
   return send_from_directory('ui', path)

@app.route('/api/v1/lang/detection', methods=['GET'])
def detect_url():

  f_url = request.args.get('file')
  x = np.array([data_helper.turn_url_to_vector(f_url, file_vector_size=2048)])
  y = model.predict(x)
  result = model.predict_proba(x)
  return jsonify({"result": result[0].tolist()})

@app.route('/api/v1/lang/detection', methods=['POST'])
def detect_text():
  try:
    text = request.get_json()['content']
    x = np.array([data_helper.turn_text_to_vector(text, file_vector_size=2048)])
    y = model.predict(x)
    result = [100*a for a in model.predict_proba(x)] # tunr to percentage
    return jsonify({"result": result[0].tolist()})
  except Exception as e:
    print e.message
    return e.message

@app.route('/api/v1/lang/random-snippet', methods=['GET'])
def random_snippet():
  try:
    root = './data/stackoverflow-snippets/'
    lang = request.args.get('lang')
    if lang is None or len(lang) == 0:
      lang = defs.langs[int(random.uniform(0, len(defs.langs)))]
    root = root + lang + '/'
    print root
    files = os.listdir(root)
    fn = root + files[int(random.uniform(0, len(files)))]
    print fn
    with codecs.open(fn) as f:
      return f.read()
  except Exception as e:
    print e.message
    return e.message

if __name__ == '__main__':
  app.run(debug=True, use_reloader=False, host='0.0.0.0')

