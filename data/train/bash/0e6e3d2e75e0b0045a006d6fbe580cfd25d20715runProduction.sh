# Normal PHOJET MC production
./produce.sh sample-7000GeV/PixelTree-7TeV-Phojet.root sample-7000GeV/TrackletTree-PHOJET-1.root 0       100000  0 0
./produce.sh sample-7000GeV/PixelTree-7TeV-Phojet.root sample-7000GeV/TrackletTree-PHOJET-2.root 100000  200000  0 0 
./produce.sh sample-7000GeV/PixelTree-7TeV-Phojet.root sample-7000GeV/TrackletTree-PHOJET-3.root 200000  300000  0 0
./produce.sh sample-7000GeV/PixelTree-7TeV-Phojet.root sample-7000GeV/TrackletTree-PHOJET-4.root 300000  500000  0 0 

# B=0 MC production
./produce.sh sample-7000GeV/PixelTree-ATLAS-B0-v1.root sample-7000GeV/TrackletTree-B0-v1-1.root 0       500000  0 0
./produce.sh sample-7000GeV/PixelTree-ATLAS-B0-v1.root sample-7000GeV/TrackletTree-B0-v1-2.root 500001  1000000  0 0 
./produce.sh sample-7000GeV/PixelTree-ATLAS-B0-v1.root sample-7000GeV/TrackletTree-B0-v1-3.root 1000001 1500000  0 0
./produce.sh sample-7000GeV/PixelTree-ATLAS-B0-v1.root sample-7000GeV/TrackletTree-B0-v1-4.root 1500001 2000000  0 0 


# Normal MC production
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-1.root 0       500000   0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-2.root 500000  1000000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-3.root 1000000 1500000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-4.root 1500000 2000000  0 1 

./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-5.root 0       500000   0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-6.root 500000  1000000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-7.root 1000000 1500000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-8.root 1500000 2000000  0 1 


# Normal Tracklet
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-1.root 0       500000   0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-2.root 500000  1000000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-3.root 1000000 1500000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-4.root 1500000 2000000  0 1 

./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-5.root 0       500000   0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-6.root 500000  1000000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-7.root 1000000 1500000  0 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-TrackletVtx-8.root 1500000 2000000  0 1 

# addbkg 7
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbg7-1.root 0       500000   7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbg7-2.root 500000  1000000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbg7-3.root 1000000 1500000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbg7-4.root 1500000 2000000  7 1 

./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbg7-5.root 0       500000   7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbg7-6.root 500000  1000000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbg7-7.root 1000000 1500000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbg7-8.root 1500000 2000000  7 1 

# addbg M dependent


./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbgM-test.root 0       50000   7 1 


./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbgM-1.root 0       500000   7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbgM-2.root 500000  1000000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbgM-3.root 1000000 1500000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-addbgM-4.root 1500000 2000000  7 1 

./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbgM-5.root 0       500000   7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbgM-6.root 500000  1000000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbgM-7.root 1000000 1500000  7 1 
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-addbgM-8.root 1500000 2000000  7 1 


# PixelCounting
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-PixelCounting-1.root 0       500000   0 1 0 1 1
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-PixelCounting-2.root 500000  1000000  0 1 0 1 1
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-PixelCounting-3.root 1000000 1500000  0 1 0 1 1
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-PixelCounting-4.root 1500000 2000000  0 1 0 1 1

#Tracklet with Cut
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-cutClusterSize-1.root 0       500000   0 1 0 1 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-cutClusterSize-2.root 500000  1000000  0 1 0 1 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-cutClusterSize-3.root 1000000 1500000  0 1 0 1 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-cutClusterSize-4.root 1500000 2000000  0 1 0 1 0

#Tracklet with Random Vertex
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-randomVtx-1.root 0       500000   0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-randomVtx-2.root 500000  1000000  0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-randomVtx-3.root 1000000 1500000  0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-randomVtx-4.root 1500000 2000000  0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-randomVtx-5.root 0       500000   0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-randomVtx-6.root 500000  1000000  0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-randomVtx-7.root 1000000 1500000  0 0 1 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-randomVtx-8.root 1500000 2000000  0 0 1 0 0


#Tracklet with Smear Vertex
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-smearVtx-test.root 0    100000   0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-smearVtx-1.root 0       500000   0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-smearVtx-2.root 500000  1000000  0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-smearVtx-3.root 1000000 1500000  0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-1.root sample-7000GeV/TrackletTree-D6T-smearVtx-4.root 1500000 2000000  0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-smearVtx-5.root 0       500000   0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-smearVtx-6.root 500000  1000000  0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-smearVtx-7.root 1000000 1500000  0 1 0 0 0
./produce.sh sample-7000GeV/PixelTree-D6T-25B-7TeV-2.root sample-7000GeV/TrackletTree-D6T-smearVtx-8.root 1500000 2000000  0 1 0 0 0


