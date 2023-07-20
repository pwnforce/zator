# Boilerplate circuit compilation for development
# ==

# Compile circuit
circom ../HeadLayer.circom --r1cs --wasm --sym --c --prime vesta

# Generate the witness, primarily as a smoke test for the circuit
cd HeadLayer_cpp && make && cd ..

# Create out directory if it doesn't exist
if [ ! -d "../out" ]; then
  echo "Directory 'out' does not exist. Creating directory 'out'."
  mkdir "../out"
fi

# Clean up
mv HeadLayer_cpp/HeadLayer ../out
mv HeadLayer_cpp/HeadLayer.dat ../out
mv HeadLayer_js/HeadLayer.wasm ../out
mv HeadLayer.r1cs ../out
