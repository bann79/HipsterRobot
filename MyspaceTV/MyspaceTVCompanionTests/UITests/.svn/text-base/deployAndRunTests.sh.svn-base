#!/bin/sh

export UITESTS_DIR=$(pwd)

#THESE WILL NEED CHANGING DEPENDING ON WHERE THE TESTS ARE BEING RUN
DEVICE_ID=d049d4f04ac2318b16dc0c5423efbccb066f5e48
APP_BUNDLE=MyspaceTVCompanion.app 
RESULTS_DIR=/Users/elinlloyd/Documents/Companion/MSCOMP/MyspaceTVCompanionTests/UITests/results
APP_BUNDLE_PATH=/Users/elinlloyd/Library/Developer/Xcode/DerivedData/MyspaceTVCompanion-ejgleguwvaeaqwcerglxyigtyymk/Build/Products/Debug-iphoneos

rm -Rf $RESULTS_DIR
mkdir $RESULTS_DIR

./tools/transporter_chief --update
./tools/transporter_chief --device $DEVICE_ID $APP_BUNDLE_PATH/$APP_BUNDLE

echo "$@"
echo --------- Now running tests -------------
if [ $# -eq 0 ];
then 
        export TESTS=`ls *Test.js | sed 's/\(.*\)\..*/\1/'`
        for TEST in $TESTS
        do
                echo ------------ Executing testcase $TEST ----------------
                ./tools/run-test $APP_BUNDLE $TEST.js $RESULTS_DIR/$TEST/ -d $DEVICE_ID
       		./tools/transporter_chief --device $DEVICE_ID $APP_BUNDLE_PATH/$APP_BUNDLE
	 done
else
        for TEST in "$@"
        do
                echo ------------- Executing testcase $TEST ---------------
		./tools/run-test $APP_BUNDLE $TEST.js $RESULTS_DIR/$TEST/ -d $DEVICE_ID
        done
fi
