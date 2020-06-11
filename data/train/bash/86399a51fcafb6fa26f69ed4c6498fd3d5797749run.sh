#!/usr/bin/bash

#python process_futures_oi_based.py FDX FDAX > check/FDAX
#python process_futures_oi_based.py FFI LFZ > check/LFZ
#python process_futures_oi_based.py SXE FESX > check/FESX
#python process_futures_oi_based.py FCH FCE > check/FCE
#python process_futures_oi_based.py MFX MFX > check/MFX
#python process_futures_oi_based.py SXF SXF > check/SXF
#python process_futures_oi_based.py NK NKD > check/NKD
#python process_futures_oi_based.py NIY NIY > check/NIY
#python process_futures_oi_based.py AEX FTI > check/FTI
#python process_futures_oi_based.py HSI HSI > check/HSI
#python process_futures_oi_based.py HCE HHI > check/HHI
#python process_futures_oi_based.py SSG SGX > check/SGX
#python process_futures_oi_based.py YAP SPI > check/SPI
#python process_futures_oi_based.py SMI FSMI > check/FSMI
#python process_futures_oi_based.py TX TX > check/TX

#python process_futures_oi_based.py KOS KOSPI > check/KOSPI
#python process_futures_oi_based.py JTI TOPIX > check/TOPIX

#python combine_process_futures_oi_based.py BDM EBM 1 0 FGBM > check/FGBM
#python combine_process_futures_oi_based.py BDS EBS 1 0 FGBS > check/FGBS

#python combine_process_futures_oi_based.py SP ES 0.2 ES > check/ES

#python process_futures_oi_based.py TU ZT > check/ZT
#python process_futures_oi_based.py FV ZF > check/ZF
#python process_futures_oi_based.py TY ZN > check/ZN
#python process_futures_oi_based.py US ZB > check/ZB
#python process_futures_oi_based.py JGB JGBL > check/JGBL
#python process_futures_oi_based.py CU1 6E > check/6E
#python process_futures_oi_based.py JY 6J > check/6J
#python process_futures_oi_based.py AD 6A > check/6A
#python process_futures_oi_based.py BP 6B > check/6B
#python process_futures_oi_based.py CD 6C > check/6C
#python process_futures_oi_based.py MP 6M > check/6M
#python process_futures_oi_based.py NE2 6N > check/6N
#python process_futures_oi_based.py SF 6S > check/6S

#python combine_process_futures_oi_based.py C ZC 1 ZC > check/ZC
#python combine_process_futures_oi_based.py W ZW 1 ZW > check/ZW
#python combine_process_futures_oi_based.py S ZS 1 ZS > check/ZS
#python combine_process_futures_oi_based.py SM ZM 1 ZM > check/ZM
##python combine_process_futures_oi_based.py BO ZL 1 ZL > check/ZL

#python adjust_split.py data/ fund AQRIX AQMIX ABRZX QGMIX SRPFX VBLTX VTSMX
#python backward_dividend_adjust.py data/ fund AQRIX AQMIX ABRZX QGMIX SRPFX VBLTX VTSMX
#python forward_dividend_adjust.py data/ fund AQRIX AQMIX ABRZX QGMIX SRPFX VBLTX VTSMX
#python process_db.py data/ fund AQRIX AQMIX ABRZX QGMIX SRPFX VBLTX VTSMX

