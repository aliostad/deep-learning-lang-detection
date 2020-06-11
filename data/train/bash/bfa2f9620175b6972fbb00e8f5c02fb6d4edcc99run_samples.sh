clear
rm ./samples/sample_sigsegv
# Null reference
valac -g -X -rdynamic -X -w --pkg linux --pkg gee-0.8 -o ./samples/sample_sigsegv ./samples/vala_file.vala ./samples/error_sigsegv.vala ./src/Stacktrace.vala ./samples/module/OtherModule.vala
./samples/sample_sigsegv

# Uncaught error
rm ./samples/sample_sigtrap
valac -g -X -rdynamic -X -w --pkg linux --pkg gee-0.8 -o ./samples/sample_sigtrap ./samples/error_sigtrap.vala ./src/Stacktrace.vala
./samples/sample_sigtrap

# Critical assert
rm ./samples/sample_sigabrt
valac  -g -X -rdynamic -X -w --pkg linux --pkg gee-0.8 -o ./samples/sample_sigabrt ./samples/error_sigabrt.vala ./src/Stacktrace.vala
./samples/sample_sigabrt

# Configure colors
rm ./samples/sample_colors
valac  -g -X -rdynamic -X -w --pkg linux --pkg gee-0.8 -o ./samples/sample_colors ./samples/error_colors.vala ./src/Stacktrace.vala
./samples/sample_colors