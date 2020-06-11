/home/ggraves/scripts/AndroidSetup.sh
sftp -b /home/ggraves/scripts/cmds ggraves@pico.metrobg.com

/home/ggraves/scripts/loadIV-ADDL.pl    
/home/ggraves/scripts/loadAP-VENFIL.pl  
/home/ggraves/scripts/loadAR-CCLASS.pl 
/home/ggraves/scripts/loadAR-CTYPE.pl  
/home/ggraves/scripts/updAR-CUSMAS.pl  
/home/ggraves/scripts/loadAR-CUSMAS.pl 
/home/ggraves/scripts/loadAR-SLSMAN.pl 
/home/ggraves/scripts/loadIV-ITMFIL.pl  
/home/ggraves/scripts/loadIV-MCODE.pl   
/home/ggraves/scripts/loadIV-PCLASS.pl 
AGHOME=/home/ag6;TERM=xterm;export AGHOME TERM;/home/ag6/bin/show /tmp/IV-STATUS > /tmp/iv-keys
/home/ggraves/scripts/loadIV-STATUS.pl 
/home/ggraves/scripts/loadIV-UOFM.pl   
