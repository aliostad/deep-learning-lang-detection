import numpy as np
from math import *

def rotate(a, b,angle):

     x = [80.297,-24.52]
     y = [a, b]

     xx = y[0]-x[0]
     yy = y[1]-x[1]

     newx = (xx*cos(radians(angle))) - (yy*sin(radians(angle)))

     newy = (xx*sin(radians(angle))) + (yy*cos(radians(angle)))

     newx+= x[0]

     newy+= x[1]

     return newx,newy


num_lines = sum(1 for line in open('field0.dat'))

for_save_objid = np.array(())

for_save_longitude = np.array(())
for_save_latitude = np.array(())
for_save_mag_obs_g = np.array(())
for_save_mag_obs_r = np.array(())
for_save_mag_obs_i = np.array(())
for_save_l_rot = np.array(())
for_save_b_rot = np.array(())




data_field = np.loadtxt('field0.dat', delimiter = ',', skiprows=1)

objid      = data_field[:,0]
longitude  = data_field[:,1]
latitude   = data_field[:,2]
mag_obs_g  = data_field[:,3]
mag_obs_r  = data_field[:,4]
mag_obs_i  = data_field[:,5]

n_objects = len(mag_obs_r)
l_rot = np.zeros(n_objects)
b_rot = np.zeros(n_objects)


for obj in range(n_objects):


     l_rot[obj], b_rot[obj] = rotate(longitude[obj],latitude[obj],70)


for_save_objid      = np.concatenate((for_save_objid, objid))
for_save_longitude  = np.concatenate((for_save_longitude, longitude))
for_save_latitude   = np.concatenate((for_save_latitude, latitude))
for_save_mag_obs_g  = np.concatenate((for_save_mag_obs_g, mag_obs_g))
for_save_mag_obs_r  = np.concatenate((for_save_mag_obs_r, mag_obs_r))
for_save_mag_obs_i  = np.concatenate((for_save_mag_obs_i, mag_obs_i))
for_save_l_rot      = np.concatenate((for_save_l_rot, l_rot))
for_save_b_rot      = np.concatenate((for_save_b_rot, b_rot))	


save_array = np.zeros((len(for_save_objid), 8))
	 
save_array[:,0] = for_save_objid
save_array[:,1] = for_save_longitude			
save_array[:,2] = for_save_latitude
save_array[:,3] = for_save_mag_obs_g
save_array[:,4] = for_save_mag_obs_r
save_array[:,5] = for_save_mag_obs_i
save_array[:,6] = for_save_l_rot
save_array[:,7] = for_save_b_rot


save_filename = 'rotate_field.dat'

np.savetxt(save_filename, save_array, delimiter = ',')
	

for_save_objid = np.array(())
for_save_longitude = np.array(())
for_save_latitude = np.array(())
for_save_mag_obs_g = np.array(())
for_save_mag_obs_r = np.array(())
for_save_mag_obs_i = np.array(())
for_save_l_rot = np.array(())
for_save_b_rot = np.array(())

rotate(a,b,angle)