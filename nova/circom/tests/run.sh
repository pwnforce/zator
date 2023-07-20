#!/bin/bash

if [[ $1 == "setup" ]]; then
  # Run the smoke tests
  ./head_layer_smoke_test.sh
  ./MiMC3D_smoke.sh
  ./backbone1_smoke_cpp.sh
  ./backbone2_smoke_cpp.sh
  ./backbone3_smoke_cpp.sh
elif [[ $1 == "clean" ]]; then
  # Clean up the directories and files
  rm -rf Backbone1_cpp/
  rm -rf Backbone2_cpp/
  rm -rf Backbone3_cpp/
  rm -rf HeadLayer_cpp/
  rm -rf MiMC3D_cpp/
  rm -rf Backbone1_js/
  rm -rf Backbone2_js/
  rm -rf Backbone3_js/
  rm -rf HeadLayer_js/
  rm -rf MiMC3D_js/
  rm -rf *.sym
  rm -rf *.zkey
  rm -rf *.dat
else
  echo "Invalid argument. Please specify 'setup' or 'clean'."
fi
