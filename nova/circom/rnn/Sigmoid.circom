pragma circom 2.0.0;

// Sigmoid
template Sigmoid () {
    signal input in;
    signal output out;
    signal x2 <== in * in;
    signal x3 <== x2 * in;
    signal x4 <== x3 * in;
    signal x5 <== x4 * in;
    signal sum [4];
    sum[0] <== 240;
    sum[1] <== sum[0] + (120 * in);
    sum[2] <== sum[1] - (10 * x3);
    sum[3] <== sum[2] + x5;
    out <== sum[3];
}
// component main { public [in] } = Sigmoid();
