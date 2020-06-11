


# Adam Maus & Brian Nixon
# CS761 Final Project
# Updated: 2012-04-24

import numpy
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import ImageGrid

class CAE_Save(object):
  def __init__(self,
               save_fig_name='results',
               save_cae_name='cae'
               ):
    self.save_fig_name = save_fig_name
    self.save_cae_name = save_cae_name
  def save_fig(self, target, reconstruction):
    fig = plt.figure(1, (1,2))
    grid = ImageGrid(fig, 111, nrows_ncols = (1, 2), axes_pad=0.1)
    grid[0].imshow(target)
    grid[1].imshow(reconstruction)
    plt.savefig(self.save_fig_name)
    
  def save_cae(self,
               W,
               c,
               b,
               n_hidden,
               learning_rate,
               jacobi_penalty,
               batch_size,
               epochs,
               schatten_p,
               loss,
               X ):
    # Output the CAE to a file
    CAE_params = numpy.array([n_hidden,
               learning_rate,
               jacobi_penalty,
               batch_size,
               epochs,
               schatten_p,
               loss])
    # Save the training data used in X
    numpy.savez(self.save_cae_name,
                W=W, c=c, b=b, CAE_params=CAE_params, X=X)

def main():
    pass

if __name__ == '__main__':
    main()
