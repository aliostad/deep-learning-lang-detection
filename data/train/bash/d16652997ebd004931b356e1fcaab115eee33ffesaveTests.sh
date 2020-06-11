#!/usr/bin/env bash



#Write every 4 second
backupDELAY="$TTK_WRITE_DELAY"
TTK_WRITE_DELAY=4


backupFUNC_PREFIX="$TTK_STORAGE_PREFIX"
TTK_STORAGE_PREFIX="test"
test_fname="test_doSaveLog"
stub "$test_fname"

#Simutlate 4 one second writes
saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 1" 1

saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 1" 1

saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 1" 1

saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 1" 0


#Simulate 4 one second writes
saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 2" 1

saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 2" 1

saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 2" 1

saveLog "asd" 1;
assert_raises "stub_called_exactly_times $test_fname 2" 0




assert_end "Save tests"
restore "forceSaveLog";
TTK_STORAGE_PREFIX="$backupFUNC_PREFIX"
TTK_WRITE_DELAY="$backupDELAY";
