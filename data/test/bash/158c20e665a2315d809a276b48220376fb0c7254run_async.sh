#/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:LongScintillator:Model_routines
echo Running all programs
./ModelScin_ideal/ModelScin_ideal_app > 1.log &
./ModelScin_length/ModelScin_length_app > 2.log &
./ModelScin_sigma_l/ModelScin_sigma_length_app > 3.log &
./ModelScin_sigma_n/ModelScin_sigma_app >4.log &
./ModelScin/ModelScin_app > 5.log &
./ModelScin_coord/ModelScin_coord_app > 6.log &
./ModelScin_coord_2/ModelScin_coord_2_app >7.log &
./theory/theory_app > 8.log &
./Comparement/Comparement_app > 9.log &
./ModelScin_n/ModelScin_n_app > A.log &
echo DONE!!!
