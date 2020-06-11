#/bin/bash
echo "COMPILING..."
(cd LongScintillator;./buildme.sh)
if (( $? )); then exit 1; fi
(cd Model_routines;qmake model_routines.pro;make clean all)
if (( $? )); then exit 1; fi
(cd ModelScin;qmake ModelScin.pro;make clean all)
(cd ModelScin_coord;qmake ModelScin_coord.pro;make clean all)
(cd ModelScin_coord_2;qmake ModelScin_coord_2.pro;make clean all)
(cd ModelScin_sigma_n;qmake ModelScin_sigma_n.pro;make clean all)
(cd ModelScin_length;qmake ModelScin_length.pro;make clean all)
(cd ModelScin_ideal;qmake ModelScin_ideal.pro;make clean all)
(cd ModelScin_sigma_l;qmake ModelScin_sigma_l.pro;make clean all)
(cd ModelScin_n; qmake ModelScin_n.pro; make clean all)
(cd theory;qmake theory.pro;make clean all)
(cd Comparement;qmake Comparement.pro;make clean all)
echo "done."
