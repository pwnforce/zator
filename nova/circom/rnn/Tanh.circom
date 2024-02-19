pragma circom 2.0.0;

// Tanh
template Tanh () {
    signal input in;
    signal output out;
    signal x2 <== in * in;
    signal x3 <== x2 * in;
    signal x4 <== x3 * in;
    signal x5 <== x4 * in;
    signal tanh [3];
    tanh[0] <== 15 * in;
    tanh[1] <== tanh[0] - (5 * x3);
    tanh[2] <== tanh[1] + (2 * x5);
    out <== tanh[2];
}
// component main { public [in] } = Tanh();
