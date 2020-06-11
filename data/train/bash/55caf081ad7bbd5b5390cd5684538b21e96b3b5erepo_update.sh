#!/bin/sh
# SVN update runs automatically at 7 am everyday
# Then a mail is sent out to rahuluncc@gmail.com (done by 'ray')

datestamp=`date` 
echo
echo "Repository Sync started at" $datestamp > ~/update_repo.log
echo
echo "==================================================" >> ~/update_repo.log

# Update Lab SVN
echo "svn up ~/svn/rcc" >> ~/update_repo.log
svn up ~/svn/rcc >> ~/update_repo.log
echo "==================================================" >> ~/update_repo.log
echo "svn up ~/svn/reports" >> ~/update_repo.log
svn up ~/svn/reports >> ~/update_repo.log
echo "==================================================" >> ~/update_repo.log
echo "svn up ~/svn/proposals" >> ~/update_repo.log
svn up ~/svn/proposals >> ~/update_repo.log
echo "==================================================" >> ~/update_repo.log
echo "svn up ~/svn/dbes" >> ~/update_repo.log
svn up ~/svn/dbes >> ~/update_repo.log
echo "==================================================" >> ~/update_repo.log
cd

# Update Opencores - Amber 
echo "svn up /home/rsharm14/storage/amber_opencores/" >> ~/update_repo.log
svn up /home/rsharm14/storage/amber_opencores/ >> ~/update_repo.log
echo "==================================================" >> ~/update_repo.log
# Update Opencores - OpenRISC
echo "svn up /home/rsharm14/storage/openrisc_opencores/" >> ~/update_repo.log
svn up /home/rsharm14/storage/openrisc_opencores/ >> ~/update_repo.log
echo "==================================================" >> ~/update_repo.log

# Update Xilinx GIT repository
cd ~/repository/sw/xilinx_git
for dir in *
do
  cd $dir
  echo $PWD >> ~/update_repo.log
  git pull >> ~/update_repo.log
  cd ..
  echo "==================================================" >> ~/update_repo.log
done
cd
echo
datestamp=`date` 
echo "Repository Sync completed at" $datestamp >> ~/update_repo.log
echo 

#### Following 2 lines have been disabled for 'freeman' test run ###
# A Second cron job on 'ray' mails the file daily at 8 am to rahuluncc@gmail.com
# A Third cron job on 'ray' deletes the log file at 9 am

# Mail test: 6th feb 2012
cat ~/update_repo.log | mail -s "Auto-update SVN + GIT report" rahuluncc@gmail.com

# Delete log file
/bin/rm -rf ~/update_repo.log

