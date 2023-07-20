# ==
# Boilerplate circuit compilation for development
# ==

LABEL=MiMC3D

# Compile circuit
circom ../${LABEL}.circom --r1cs --wasm --sym --c --prime vesta
# Generate the witness, primarily as a smoke test for the circuit
make -C ${LABEL}_cpp/

# Create out directory if it doesn't exist
if [ ! -d "../out" ]; then
  echo "Directory 'out' does not exist. Creating directory 'out'."
  mkdir "../out"
fi

# Clean up
mv ${LABEL}_cpp/${LABEL} ../out
mv ${LABEL}_cpp/${LABEL}.dat ../out
mv ${LABEL}.r1cs ../out
mv ${LABEL}_js/${LABEL}.wasm ../out
