import private_consts

import os, pickle, random

def save_data(vocabulary, examples, cal_only):
  save_file = str()
  if cal_only:
    save_file = os.path.expanduser(private_consts.SAVE_DIR)+"uninflated_data.{0}_cal_only.pickle".format(len(examples))
  else:
    save_file = os.path.expanduser(private_consts.SAVE_DIR)+"uninflated_data.{0}.pickle".format(len(examples))
  pickle.dump( {"vocabulary":vocabulary, "examples":examples} , open( save_file, "wb" ) )

def save_model(model, name, size, cal_only):
  print "saving model {0} {1}".format(name,size)

  save_file = os.path.expanduser(private_consts.SAVE_DIR)+"{0}.{1}.pickle".format(name, size)
  if cal_only:
    save_file = os.path.expanduser(private_consts.SAVE_DIR)+"{0}.{1}_cal_only.pickle".format(name, size)
  pickle.dump( model , open( save_file, "wb" ) )

def load_model(name, size, cal_only):
  save_file = os.path.expanduser(private_consts.SAVE_DIR)+"{0}.{1}.pickle".format(name, size)
  if cal_only:
    save_file = os.path.expanduser(private_consts.SAVE_DIR)+"{0}.{1}_cal_only.pickle".format(name, size)
  return pickle.load( open( save_file, "rb" ) )

def load_data(num_examples, cal_only = False):
  save_file = str()
  if cal_only:
    save_file = os.path.expanduser(private_consts.SAVE_DIR)+"uninflated_data.{0}_cal_only.pickle".format(num_examples)
  else:
    save_file = os.path.expanduser(private_consts.SAVE_DIR)+"uninflated_data.{0}.pickle".format(num_examples)
  uninflated_data = pickle.load( open( save_file, "rb" ) )

  vocabulary = uninflated_data["vocabulary"]

  x = []
  t = [example[1] for example in uninflated_data["examples"]]
  for example in uninflated_data["examples"]:
    tokens_list = [0] * len(vocabulary)
    for token in example[0]:
      tokens_list[list(vocabulary).index(token)] = 1
    x.append(tokens_list)

  return (x,t, vocabulary)

def load_and_split_data(num_examples = 100, percent_train = 0.8):
  (x, t, v) = load_data(num_examples)
  num_train = int(num_examples*percent_train)

  train_indices = random.sample(range(num_examples), num_train)

  x_train = [x[i] for i in train_indices]
  x_test = [x[i] for i in range(num_examples) if i not in train_indices]
  t_train = [t[i] for i in train_indices]
  t_test = [t[i] for i in range(num_examples) if i not in train_indices]

  return ((x_train, t_train), (x_test, t_test))
