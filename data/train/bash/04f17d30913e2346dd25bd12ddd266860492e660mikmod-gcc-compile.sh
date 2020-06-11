CROSS_PREFFIX='/opt/mingw32ce/bin/arm-mingw32ce-'
INCLUDE='-Ilibmikmod/include -Ilibmikmod/win32'
OPT='-march=armv4 -mtune=xscale -DMIKMOD_EXPORTS -DUNICODE -DNDEBUG -DFIXED_POINT -O3'
${CROSS_PREFFIX}gcc $OPT -c -o drv_nos.o libmikmod/drivers/drv_nos.c $INCLUDE
SRC_PATH='libmikmod/loaders'
#NAMES=(load_669 load_amf load_asy load_dsm load_far load_gdm load_imf load_it load_m15 load_med load_mod load_mtm load_okt load_s3m load_stm load_stx load_ult load_uni load_xm)
NAMES=(load_669 load_amf load_dsm load_far load_gdm load_imf load_it load_m15 load_med load_mod load_mtm load_okt load_s3m load_stm load_stx load_ult load_uni load_xm)

for name in ${NAMES[@]}
   do
      ${CROSS_PREFFIX}gcc $OPT -c -o ${name}.o libmikmod/loaders/${name}.c $INCLUDE
   done
NAMES=(mdriver mloader mlreg mlutil mplayer munitrk mwav npertab sloader virtch virtch2 virtch_common)
for name in ${NAMES[@]}
   do
      ${CROSS_PREFFIX}gcc $OPT -c -o ${name}.o libmikmod/playercode/${name}.c $INCLUDE
   done   
${CROSS_PREFFIX}gcc $OPT -c -o mmerror.o libmikmod/mmio/mmerror.c $INCLUDE
${CROSS_PREFFIX}gcc $OPT -c -o mmio.o libmikmod/mmio/mmio.c $INCLUDE

${CROSS_PREFFIX}gcc $OPT -o stdafx.o -c stdafx.c $INCLUDE
${CROSS_PREFFIX}gcc $OPT -o mikmod.o -c mikmod.c $INCLUDE 

#${CROSS_PREFFIX}gcc $OPT -shared -o mikmod.plg drv_nos.o load_669.o load_amf.o load_asy.o load_dsm.o load_far.o load_gdm.o load_imf.o load_it.o load_m15.o load_med.o load_mod.o load_mtm.o load_okt.o load_s3m.o load_stm.o load_stx.o load_ult.o load_uni.o load_xm.o mdriver.o mloader.o mlreg.o mlutil.o mplayer.o munitrk.o mwav.o npertab.o sloader.o virtch.o virtch2.o virtch_common.o mmerror.o mmio.o stdafx.o mikmod.o -L../armplg/libcommon -lcommon
${CROSS_PREFFIX}gcc $OPT -shared -o mikmod.plg drv_nos.o load_669.o load_amf.o load_dsm.o load_far.o load_gdm.o load_imf.o load_it.o load_m15.o load_med.o load_mod.o load_mtm.o load_okt.o load_s3m.o load_stm.o load_stx.o load_ult.o load_uni.o load_xm.o mdriver.o mloader.o mlreg.o mlutil.o mplayer.o munitrk.o mwav.o npertab.o sloader.o virtch.o virtch2.o virtch_common.o mmerror.o mmio.o stdafx.o mikmod.o -L../armplg/libcommon -lcommon

${CROSS_PREFFIX}strip mikmod.plg