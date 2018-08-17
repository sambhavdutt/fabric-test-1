#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0

DAILYDIR="$GOPATH/src/github.com/hyperledger/fabric-test/regression/daily"
cd $DAILYDIR

echo "========== System Test Performance tests using PTE and NL tools..."
cd $GOPATH/src/github.com/hyperledger/fabric-test/tools/PTE
npm install
  if [ $? != 0 ]; then
     echo "------> Failed to install npm. Cannot run pte test suite."
     exit 1
  else
     echo "------> Successfully installed npm."
  fi

cd $DAILYDIR && py.test -v --junitxml results_systest_pte.xml systest_pte.py
copy_logs $?
# Create Logs directory
mkdir -p $WORKSPACE/Docker_Container_Logs
artifacts() {

    echo "---> Archiving generated logs"
    rm -rf $WORKSPACE/archives
    mkdir -p "$WORKSPACE/archives"
    mv "$WORKSPACE/Docker_Container_Logs" $WORKSPACE/archives/
}
# Capture docker logs of each container
logs() {

   cp *.log $WORKSPACE/LOGS/$1.log
   cp *.xml $WORKSPACE/LOGS/$1.xml
    echo

}

copy_logs() {

# Call logs function
logs $1

if [ $1 != 0 ]; then
    artifacts
    exit 1
fi
}
