cdir=`pwd`
rdir=`cd \`dirname $0\`;pwd`
basedir=`dirname $rdir`

for op in $*;do 
   if [ "${op:0:1}" = "-" ]; then
	mode="${op#-*}"
   fi
done

if [ "$mode" = "b" ]; then
    [ -d $basedir/.repo/projects/frameworks/av_quarx2k.git ] \
	|| cp -r $basedir/.repo/projects/frameworks/av.git $basedir/.repo/projects/frameworks/av_quarx2k.git
    [ -d $basedir/.repo/projects/frameworks/base_quarx2k.git ] \
	|| cp -r $basedir/.repo/projects/frameworks/base.git $basedir/.repo/projects/frameworks/base_quarx2k.git
    [ -d $basedir/.repo/projects/frameworks/native_quarx2k.git ] \
	|| cp -r $basedir/.repo/projects/frameworks/native.git $basedir/.repo/projects/frameworks/native_quarx2k.git
    [ -d $basedir/.repo/projects/frameworks/opt/telephony_quarx2k.git ] \
	|| cp -r $basedir/.repo/projects/frameworks/opt/telephony.git $basedir/.repo/projects/frameworks/opt/telephony_quarx2k.git
    [ -d $basedir/.repo/projects/system/core_quarx2k.git ] \
	|| cp -r $basedir/.repo/projects/system/core.git $basedir/.repo/projects/system/core_quarx2k.git
    [ -d $basedir/.repo/projects/hardware/ril_quarx2k.git ] \
	|| cp -r $basedir/.repo/projects/hardware/ril.git $basedir/.repo/projects/hardware/ril_quarx2k.git
    [ -d $basedir/.repo/projects/bootable/recovery_twrp.git ] \
	|| cp -r $basedir/.repo/projects/bootable/recover.git $basedir/.repo/projects/bootable/recover_twrp.git
elif [ "$mode" = "r" ]; then
    rm -rf $basedir/frameworks/av $basedir/.repo/projects/frameworks/av.git;
    cp -r $basedir/.repo/projects/frameworks/av_quarx2k.git $basedir/.repo/projects/frameworks/av.git

    rm -rf $basedir/frameworks/base $basedir/.repo/projects/frameworks/base.git;
    cp -r $basedir/.repo/projects/frameworks/base_quarx2k.git $basedir/.repo/projects/frameworks/base.git

    rm -rf $basedir/frameworks/native $basedir/.repo/projects/frameworks/native.git;
    cp -r $basedir/.repo/projects/frameworks/native_quarx2k.git $basedir/.repo/projects/frameworks/native.git

    rm -rf $basedir/frameworks/opt/telephony $basedir/.repo/projects/frameworks/opt/telephony.git;
    cp -r $basedir/.repo/projects/frameworks/opt/telephony_quarx2k.git $basedir/.repo/projects/frameworks/opt/telephony.git

    rm -rf $basedir/system/core $basedir/.repo/projects/system/core.git;
    cp -r $basedir/.repo/projects/system/core_quarx2k.git $basedir/.repo/projects/system/core.git

    rm -rf $basedir/hardware/ril $basedir/.repo/projects/hardware/ril.git;
    cp -r $basedir/.repo/projects/hardware/ril_quarx2k.git $basedir/.repo/projects/hardware/ril.git
    
    rm -rf $basedir/bootable/recovery $basedir/.repo/projects/bootable/recover.git
    cp -r $basedir/.repo/projects/bootable/recover_twrp.git $basedir/.repo/projects/bootable/recover.git

    cd $basedir
    repo sync
    cd $rdir
fi

