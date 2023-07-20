# Boilerplate circuit compilation for development
# ==

# Compile circuit
circom ../TailLayer.circom --r1cs --wasm --sym --c --prime vesta

# Generate the witness, primarily as a smoke test for the circuit
make -C TailLayer_cpp/

# Create out directory if it doesn't exist
if [ ! -d "../out" ]; then
  echo "Directory 'out' does not exist. Creating directory 'out'."
  mkdir "../out"
fi

# Clean up
mv TailLayer_cpp/TailLayer ../out
mv TailLayer_cpp/TailLayer.dat ../out
mv TailLayer.r1cs ../out
mv TailLayer_js/TailLayer.wasm ../out
