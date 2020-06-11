#!/bin/bash

# dropped all 'cfappend' samples (see Matt's original script for the complete list)
# /home/mrelich/workarea/SUSY2012/SusyAna2012/run/anaplots/groupMCwChargeFlip.sh

ending="_Jun06_n0139"
outdir="merged"
addition=""
append=${ending}.AnaHists 
cfappend=${ending}.ChargeFlipHists


# data
hadd -f ${outdir}/data_physics_Egamma${append}${addition}.root \
    period?.physics_Egamma${append}.root
hadd -f ${outdir}/data_physics_Muons${append}${addition}.root \
    period?.physics_Muons${append}.root

# ttbar
hadd -f ${outdir}/top${append}${addition}.root \
    ttbar_LeptonFilter${append}.root \
    ttbarW${append}.root \
    ttbarZ${append}.root  \
    ttbarWj${append}.root \
    ttbarZj${append}.root  \
    SingleTopWtChanIncl${append}.root \

# Z+jet
hadd -f ${outdir}/Zjet${append}${addition}.root \
    Sherpa_CT10_Zee${append}.root \
    Sherpa_CT10_Zmumu${append}.root \
    ZeeNp0Excl_Mll10to60${append}.root \
    ZeeNp1Excl_Mll10to60${append}.root \
    ZeeNp2Excl_Mll10to60${append}.root \
    ZeeNp3Excl_Mll10to60${append}.root \
    ZeeNp4Excl_Mll10to60${append}.root \
    ZmumuNp0Excl_Mll10to60${append}.root \
    ZmumuNp1Excl_Mll10to60${append}.root \
    ZmumuNp2Excl_Mll10to60${append}.root \
    ZmumuNp3Excl_Mll10to60${append}.root \
    ZmumuNp4Excl_Mll10to60${append}.root \
    Sherpa_CT10_Ztautau${append}.root \
    ZtautauNp0Excl_Mll10to60${append}.root \
    ZtautauNp1Excl_Mll10to60${append}.root \
    ZtautauNp2Excl_Mll10to60${append}.root \
    ZtautauNp3Excl_Mll10to60${append}.root \

 
# Diboson (Z)
hadd -f ${outdir}/ZZ${append}${addition}.root \
    llll_ZZ${append}.root \
    llnunu_ZZ${append}.root \
    ZZ4lep${append}.root \
    ZZ4e${append}.root \
    ZZ4mu${append}.root \
    ZZ2e2mu${append}.root \


hadd -f ${outdir}/WZ${append}${addition}.root \
    lllnu_WZ${append}.root \


# WW
hadd -f ${outdir}/WW${append}${addition}.root \
    llnunu_WW${append}.root \
    llnunu_SS_EW6${append}.root \
    llnunujj_SS${append}.root \
    WpWmenuenu${append}.root \
    WpWmenumunu${append}.root \
    WpWmenutaunu${append}.root \
    WpWmmunumunu${append}.root \
    WpWmmunutaunu${append}.root \
    WpWmtaunuenu${append}.root \
    WpWmtaunumunu${append}.root \
    WpWmtaunutaunu${append}.root \


# Z+jet Alpgen

hadd -f ${outdir}/Zjet${append}${addition}.root \
    AlpgenPythia_P2011C_ZeeNp0${append}.root        \
    AlpgenPythia_P2011C_ZeeNp1${append}.root        \
    AlpgenPythia_P2011C_ZeeNp2${append}.root        \
    AlpgenPythia_P2011C_ZeeNp3${append}.root        \
    AlpgenPythia_P2011C_ZeeNp4${append}.root        \
    AlpgenPythia_P2011C_ZeeNp5${append}.root        \
    AlpgenPythia_P2011C_ZeebbNp0${append}.root      \
    AlpgenPythia_P2011C_ZeebbNp1${append}.root      \
    AlpgenPythia_P2011C_ZeebbNp2${append}.root      \
    AlpgenPythia_P2011C_ZeebbNp3${append}.root      \
    AlpgenPythia_P2011C_ZeeccNp0${append}.root      \
    AlpgenPythia_P2011C_ZeeccNp1${append}.root      \
    AlpgenPythia_P2011C_ZeeccNp2${append}.root      \
    AlpgenPythia_P2011C_ZeeccNp3${append}.root      \
    AlpgenPythia_P2011C_ZmumuNp0${append}.root      \
    AlpgenPythia_P2011C_ZmumuNp1${append}.root      \
    AlpgenPythia_P2011C_ZmumuNp2${append}.root      \
    AlpgenPythia_P2011C_ZmumuNp3${append}.root      \
    AlpgenPythia_P2011C_ZmumuNp4${append}.root      \
    AlpgenPythia_P2011C_ZmumuNp5${append}.root      \
    AlpgenPythia_P2011C_ZmumubbNp0${append}.root    \
    AlpgenPythia_P2011C_ZmumubbNp1${append}.root    \
    AlpgenPythia_P2011C_ZmumubbNp2${append}.root    \
    AlpgenPythia_P2011C_ZmumubbNp3${append}.root    \
    AlpgenPythia_P2011C_ZmumuccNp0${append}.root    \
    AlpgenPythia_P2011C_ZmumuccNp1${append}.root    \
    AlpgenPythia_P2011C_ZmumuccNp2${append}.root    \
    AlpgenPythia_P2011C_ZmumuccNp3${append}.root    \
    AlpgenPythia_P2011C_ZtautauNp0${append}.root    \
    AlpgenPythia_P2011C_ZtautauNp1${append}.root    \
    AlpgenPythia_P2011C_ZtautauNp2${append}.root    \
    AlpgenPythia_P2011C_ZtautauNp3${append}.root    \
    AlpgenPythia_P2011C_ZtautauNp4${append}.root    \
    AlpgenPythia_P2011C_ZtautauNp5${append}.root    \
    AlpgenPythia_P2011C_ZtautaubbNp0${append}.root  \
    AlpgenPythia_P2011C_ZtautaubbNp1${append}.root  \
    AlpgenPythia_P2011C_ZtautaubbNp2${append}.root  \
    AlpgenPythia_P2011C_ZtautaubbNp3${append}.root  \
    AlpgenPythia_P2011C_ZtautauccNp0${append}.root  \
    AlpgenPythia_P2011C_ZtautauccNp1${append}.root  \
    AlpgenPythia_P2011C_ZtautauccNp2${append}.root  \
    AlpgenPythia_P2011C_ZtautauccNp3${append}.root
