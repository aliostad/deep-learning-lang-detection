#! /usr/bin/env python
# import necessary modules
import polyadcirc.run_framework.random_wall as rmw

base_dir = '/h1/lgraham/workspace'
grid_dir = base_dir + '/ADCIRC_landuse/Inlet/inputs/poly_walls'
save_dir = base_dir + '/ADCIRC_landuse/Inlet/runs/poly_wall'
basis_dir = base_dir +'/ADCIRC_landuse/Inlet/landuse_basis/gap/beach_walls_2lands'

# set up saving
save_file = 'py_save_file'

main_run, domain, mann_pts, wall_pts, points = rmw.loadmat(save_file+'0',
        base_dir, grid_dir, save_dir+'_0', basis_dir)


for i in xrange(1, 7):
    save_file2 = save_file+str(i)
    save_dir2 = save_dir+'_'+str(i)
    other_run, domain, mann_pts2, wall_pts2, points2 = rmw.loadmat(save_file2, 
            base_dir, grid_dir, save_dir2, basis_dir)
    run, points = main_run.concatenate(other_run, points, points2)

mdat = dict()
mdat['points'] = points

main_run.update_mdict(mdat)
main_run.save(mdat, 'poly7_file')


