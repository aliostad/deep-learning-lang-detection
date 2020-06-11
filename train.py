import numpy as np
import data_helper
from keras.models import Sequential, Model
from keras.layers import Activation, Dense, Dropout, Flatten, Input, Conv1D, MaxPooling1D
from keras.layers.merge import Concatenate
import defs


np.random.seed(2)

# data parameters
n_max_files = 2000 # max number of files per class to load
number_of_classes = len(defs.langs)

# Model Hyperparameters
sequence_length = defs.file_characters_truncation_limit
filter_sizes = (3, 9, 19)
pooling_sizes = (3, 9, 19)
num_filters = 128
dropout_prob = (0.25, 0.5)
hidden_dims = 128
number_of_quantised_characters = len(defs.supported_chars)


# Training parameters
batch_size = 100
num_epochs = 20
val_split = 0.1


# Data Preparatopn
# ==================================================
#
# Load data
print("Loading data...")
x, y, z = data_helper.get_input_and_labels(file_vector_size=sequence_length, max_files=n_max_files, breakup=True)

# Shuffle data
shuffle_indices = np.random.permutation(np.arange(len(y)))
x_shuffled = x[shuffle_indices]
y_shuffled = y[shuffle_indices]

# Setting up the model
graph_in = Input(shape=(sequence_length, number_of_quantised_characters))
convs = []
for i in range(0, len(filter_sizes)):
    conv = Conv1D(filters=num_filters,
                  kernel_size=filter_sizes[i],
                  padding='valid',
                  activation='relu',
                  strides=1)(graph_in)
    pool = MaxPooling1D(pool_size=pooling_sizes[i])(conv)
    flatten = Flatten()(pool)
    convs.append(flatten)

if len(filter_sizes) > 1:
    out = Concatenate()(convs)
else:
    out = convs[0]

graph = Model(inputs=graph_in, outputs=out)

# main sequential model
model = Sequential()

model.add(Dropout(dropout_prob[0], input_shape=(sequence_length, number_of_quantised_characters)))
model.add(graph)
model.add(Dense(hidden_dims))
model.add(Dropout(dropout_prob[1]))
model.add(Dense(number_of_classes))
model.add(Activation('softmax'))
model.compile(loss='categorical_crossentropy', optimizer='adadelta', metrics=['accuracy'])

# Training model
# ==================================================
model.fit(x_shuffled, y_shuffled, batch_size=batch_size,
          epochs=num_epochs, validation_split=val_split, verbose=1)

model.save('save_tmp.h5')
