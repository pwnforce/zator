pragma circom 2.0.0;
include "./Sigmoid.circom";
include "./Tanh.circom";
//   def Gru(self, previous_hidden_state, x):
//         """
//         GRU Equations
//         """
//         z = tf.sigmoid(tf.matmul(x, self.Wz) + self.bz)
//         r = tf.sigmoid(tf.matmul(x, self.Wr) + self.br)

//         h_ = tf.tanh(tf.matmul(x, self.Wx) +
//                      tf.matmul(previous_hidden_state, self.Wh) * r)

//         current_hidden_state = tf.multiply(
//             (1 - z), h_) + tf.multiply(previous_hidden_state, z)

//         return current_hidden_state
// GRU
template GRU () {
    signal input previous_hidden_state, x, wz, wr, wx, wh, bz, br;
    signal output current_hidden_state;
    signal z, r, h_;
    component sig1 = Sigmoid ();
    component sig2 = Sigmoid ();
    component tanh = Tanh ();
    sig1.in <== (wz * x) + bz; 
    z <== sig1.out;
    sig2.in <== (wr * x) + br;
    r <== sig2.out;
    signal tmp <== (wx * x);
    signal tmp2 <== previous_hidden_state * wh;
    tanh.in <== tmp + (tmp2 * r);
    h_ <== tanh.out;
    signal tmp3 <== (1-z) * h_;
    signal tmp4 <== previous_hidden_state * z;
    current_hidden_state <== tmp3 + tmp4;
}
component main { public [x] } = GRU();

