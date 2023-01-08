#! /bin/bash

# If number of arguments less then 1; print usage and exit
if [ $# -lt 1 ]; then
	echo "Usage: $0 <tested_application> <optional: path>"
	exit 1
fi

# Setting the testing environment
tst="diff" #testing application
test_dir=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd ) #in subterminal go to the directory of the scipt and get its path
-exe="$1" #tested application from args
if [ $# -eq 2 ]
then
	cd $2
fi
test_files=(${test_dir}/*.test) # all test files have the extension of .test
success=0
fail=0

for file in "${test_files[@]}"; do
	# temporary files of encyption and decryption
	file_enc="$file.enc.tmp"
	file_dec="$file.dec.tmp"

	echo "Testing $file"

	# encrypt and decrypt the file
	$exe -e -i $file -o $file_enc -f ${test_dir}/cipher128
	$exe -d -i $file_enc -o $file_dec -f ${test_dir}/cipher128

	$exe -h -i $file
	$exe -h -i $file_dec


	# Execute diff
	$tst $file $file_dec


	# use diff exit code to determine success and failure
	e_code=$?
	if [ $e_code != 0 ]; then
		echo TESTING $file FAILED!
		((fail++))
	else
		((success++))
	fi
done

echo ========================================
echo TESTS DONE!
echo Success: $success
echo Fail: $fail
echo ========================================

# Clean up
rm ${test_dir}/*.tmp

exit 0
