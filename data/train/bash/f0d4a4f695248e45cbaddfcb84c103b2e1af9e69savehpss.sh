#! /bin/csh -f
#
#save data to HPSS
#  $1 = run name
#  $2 = u,v,w,h5  or diag    if present, save only the .u, .v or .w files
#                            (call 3 times, from 3 jobs, to save 3x faster) 
#

set name = $1
set ext = all
if ($#argv >= 2 ) then
   set ext = $2
endif


psi <<EOF
cd dns
mkdir $name
EOF

if ( ( $ext == all ) || ( $ext == diag ) ) then
   echo 'saving diagnostics'
   psi save -d dns/$name $name*.scalars-turb
   psi save -d dns/$name $name*.pscalars-turb
   psi save -d dns/$name $name*.isostr 
   psi save -d dns/$name $name*.isow2s2
   psi save -d dns/$name $name*.iso1
   psi save -d dns/$name $name*.sf
   psi save -d dns/$name $name*.cores
   psi save -d dns/$name $name*.jpdf
   psi save -d dns/$name $name*.spdf
   psi save -d dns/$name $name*.vxline
   psi save -d dns/$name $name*.tracer

   psi store -d dns/$name  $name*.scalars
   psi store -d dns/$name  $name*.spec
   psi store -d dns/$name  $name*.hspec
   psi store -d dns/$name  $name*.cospec
   psi store -d dns/$name  $name*.kspec
   psi store -d dns/$name  $name*.pspec
   psi store -d dns/$name $name*.spect
   psi store -d dns/$name $name*.cross

   if ( $ext == all ) then
      echo 'saving uvw'
      psi save -d dns/$name $name*00.h5 $name*00.u  $name*00.v   $name*00.w
      psi save -d dns/$name $name*00.vor $name*00.psi
      psi save -d dns/$name $name*00.t??.s???.???
      psi save -d dns/$name $name*00.t??.s???.???.gradxy2
   endif
else
   echo 'saving .' $ext ' files'
   #psi save -d dns/$name {$name}0003.6781.$ext $name*.$ext
   psi save -d dns/$name $name*.$ext
endif



