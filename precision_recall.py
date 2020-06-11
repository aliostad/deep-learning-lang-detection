class ClassStats:
  def __init__(self, name):
    self.tp = 0
    self.fp = 0
    self.fn = 0
    self.className = name

  def fp(self):
    return self.fp

  def tp(self):
    return self.tp

  def fn(self):
    return self.fn

  def inc_fn(self):
    self.fn += 1

  def inc_fp(self):
    self.fp += 1

  def inc_tp(self):
    self.tp += 1

  def precision(self):
    return self.tp * 1.0 / (self.tp + self.fp)

  def recall(self):
    return self.tp * 1.0 / (self.tp + self.fn)

  def get_name(self):
    return self.className

def which_class(vector, labels, threshold):
  m = len(vector)
  if m != len(labels):
    raise Exception("Length of vector and classes different")
  for i in range(0, m):
    if vector[i] >= threshold:
      return labels[i]
  return None

def calculate_precision_recall(y_expected, y_predicted, labels, threshold=0.5):
  m = len(y_expected)
  if m != len(y_predicted):
    raise Exception("Length of expected and predicted different")
  classes = dict( (l, ClassStats(l)) for l in labels)

  for i in range(0, m):
    expected = y_expected[i]
    predicted = y_predicted[i]
    expected_class = which_class(expected, labels, 1)
    predicted_class = which_class(predicted, labels, threshold)
    if predicted_class is None:
      classes[expected_class].inc_fn()
    else:
      if predicted_class == expected_class:
        classes[expected_class].inc_tp()
      else:
        classes[expected_class].inc_fn()
        classes[predicted_class].inc_fp()

  return classes