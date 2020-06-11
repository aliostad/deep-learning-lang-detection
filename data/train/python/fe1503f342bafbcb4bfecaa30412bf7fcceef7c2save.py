import numpy as np
import scipy.io as sio

save_path = "matrix_to_save/" 

def SaveAsNPY(array):
	np.save(save_path + "a.npy", array)
	return

def SaveAsMAT(array, matrix_type = 'normal'):
	matrix_size = array.shape
	sio.savemat(save_path + 'a.mat', {'array': array, 'matrix_type': str(matrix_type), 'matrix_size' : matrix_size})
	return

def SaveAsCSV(array):
	np.savetxt(save_path + "a.csv", array, fmt="%.12f", delimiter=',', header='', footer='', comments='#')
	return

def SaveAsTXT(array):
	np.savetxt(save_path + "a.txt", array, fmt="%.12f", delimiter=',', newline='\n', header='', footer='', comments='#')
	return

def SaveAsBIN(array):
	array.tofile(save_path + "a.bin", sep=' ',)
	return

if __name__ == "__main__":
	pass
