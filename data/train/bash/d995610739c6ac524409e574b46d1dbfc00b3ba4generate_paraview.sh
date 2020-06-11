np=4

rm load_time.xml
echo "<?xml version=\"1.0\" ?>
<pqevents>">>load_time.xml
for ((i=0; i<$np; i++ )) ; 
do
echo "
  <pqevent object=\"pqClientMainWindow/MainControlsToolbar/actionOpenData\" command=\"activate\" arguments=\"\" />
  <pqevent object=\"pqClientMainWindow/FileOpenDialog\" command=\"filesSelected\" arguments=\"./proc_$i/Rectangular_Domain...vtk\" />">>load_time.xml
done
echo "
</pqevents>">>load_time.xml

rm load.xml
echo "<?xml version=\"1.0\" ?>
<pqevents>">>load.xml
for ((i=0; i<$np; i++ )) ; 
do
echo "
  <pqevent object=\"pqClientMainWindow/MainControlsToolbar/actionOpenData\" command=\"activate\" arguments=\"\" />
  <pqevent object=\"pqClientMainWindow/FileOpenDialog\" command=\"filesSelected\" arguments=\"./proc_$i/Rectangular_Domain.1.vtk\" />">>load.xml
done
echo "
</pqevents>">>load.xml
