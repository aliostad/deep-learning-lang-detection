# Android Screenshot Library
############################
# Publishing script

# Create directory for package
Remove-Item dist -Recurse -ErrorAction SilentlyContinue
New-Item dist -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# Copy native application
Copy-Item native/asl-native dist/

# Copy source files
Copy-Item demo/src/pl/polidea/asl/IScreenshotProvider.aidl dist/
Copy-Item demo/src/pl/polidea/asl/ScreenshotService.java dist/

# Copy service launch scripts
Copy-Item desktop/run.* dist/

# Copy demo application
Copy-Item demo dist/demo -Recurse
Remove-Item dist/demo/bin/* -Recurse -ErrorAction SilentlyContinue
Remove-Item dist/demo/gen/* -Recurse -ErrorAction SilentlyContinue


# Copy readme file
Copy-Item readme.html dist/