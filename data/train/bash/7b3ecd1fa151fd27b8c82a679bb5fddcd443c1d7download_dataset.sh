wget http://deeplearning.net/data/mnist/mnist.pkl.gz
gunzip mnist.pkl.gz
python -c "from pylearn2.utils import serial; \
          data = serial.load('mnist.pkl'); \
          serial.save('mnist_train_X.npy', data[0][0]); \
          serial.save('mnist_train_y.npy', data[0][1].reshape((-1, 1))); \
          serial.save('mnist_valid_X.npy', data[1][0]); \
          serial.save('mnist_valid_y.npy', data[1][1].reshape((-1, 1))); \
          serial.save('mnist_test_X.npy', data[2][0]); \
          serial.save('mnist_test_y.npy', data[2][1].reshape((-1, 1)))"
rm mnist.pkl
