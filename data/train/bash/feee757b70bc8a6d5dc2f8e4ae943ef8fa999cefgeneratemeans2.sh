
source ~/catkin_ws/devel/setup.bash

APPEND=$1
for sz in "300" ; do #"150" "200" "300"
    
    FILENAME=$sz;
    (rosbag play "depth${FILENAME}cm.bag" &);
    sleep .1;
                 
    (rosrun asus_node asus_node &);

    sleep 14;

    (rosbag play report.bag &) ; 
    (rostopic echo /mean > "mean${FILENAME}cm${APPEND}.txt" &) 
    (rostopic echo /variance > "variance${FILENAME}cm${APPEND}.txt" &)

    (rostopic echo /meanG > "meanG${FILENAME}cm${APPEND}.txt" &) 
    (rostopic echo /varianceG > "varianceG${FILENAME}cm${APPEND}.txt" &)
    
    (rostopic echo /meanM > "meanM${FILENAME}cm${APPEND}.txt" &) 
    (rostopic echo /varianceM > "varianceM${FILENAME}cm${APPEND}.txt" &)
    
    (rostopic echo /meanB > "meanB${FILENAME}cm${APPEND}.txt" &) 
    (rostopic echo /varianceB > "varianceB${FILENAME}cm${APPEND}.txt" &)
    
    (rostopic echo /meantA > "meantA${FILENAME}cm${APPEND}.txt" &) 
    (rostopic echo /variancetA > "variancetA${FILENAME}cm${APPEND}.txt" &)
    
    (rostopic echo /meantM > "meantM${FILENAME}cm${APPEND}.txt" &) 
    (rostopic echo /variancetM > "variancetM${FILENAME}cm${APPEND}.txt" &)

    sleep 20;
    killall rostopic;


    sed -n "1~2p" -i'' "mean${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "mean${FILENAME}cm${APPEND}.txt"

    sed -n "1~2p" -i'' "variance${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "variance${FILENAME}cm${APPEND}.txt" 
    
    sed -n "1~2p" -i'' "meanG${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "meanG${FILENAME}cm${APPEND}.txt"

    sed -n "1~2p" -i'' "varianceG${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "varianceG${FILENAME}cm${APPEND}.txt" 
    
    sed -n "1~2p" -i'' "meanM${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "meanM${FILENAME}cm${APPEND}.txt"

    sed -n "1~2p" -i'' "varianceM${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "varianceM${FILENAME}cm${APPEND}.txt" 
    
    sed -n "1~2p" -i'' "meanB${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "meanB${FILENAME}cm${APPEND}.txt"

    sed -n "1~2p" -i'' "varianceB${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "varianceB${FILENAME}cm${APPEND}.txt" 

    sed -n "1~2p" -i'' "meantA${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "meantA${FILENAME}cm${APPEND}.txt"

    sed -n "1~2p" -i'' "variancetA${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "variancetA${FILENAME}cm${APPEND}.txt" 
    
    sed -n "1~2p" -i'' "meantM${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "meantM${FILENAME}cm${APPEND}.txt"

    sed -n "1~2p" -i'' "variancetM${FILENAME}cm${APPEND}.txt" 
    sed -i'' -e 's/data: //g' "variancetM${FILENAME}cm${APPEND}.txt" 

done
