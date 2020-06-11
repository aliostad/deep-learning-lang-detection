# Copy the files we need to .\bin
if (Test-Path bin) {
    Remove-Item bin -recurse -force
}
mkdir bin | Out-Null;
Copy-Item "CSL Ambient Sounds Tuner\bin\$env:CONFIGURATION\*" -Destination bin -Recurse -Force -Exclude @("*.pdb","*.xml")

# Copy the files we need to .\workshop
if (Test-Path workshop) {
    Remove-Item workshop -recurse -force
}
mkdir workshop | Out-Null;
mkdir workshop\Content | Out-Null;
Copy-Item PreviewImage.png -destination workshop
Copy-Item "bin/*" -destination workshop\Content -recurse
