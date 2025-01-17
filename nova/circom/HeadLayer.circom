pragma circom 2.1.1;
include "./node_modules/circomlib-ml-vesta/circuits/ReLU.circom";
include "./node_modules/circomlib-ml-vesta/circuits/circomlib/mimc.circom";
include "./node_modules/circomlib-ml-vesta/circuits/Conv2D.circom";
include "./utils/mimcsponge.circom";
include "./utils/utils.circom";
include "./utils/Division.circom";

// Template for the first (head) layer of a Convnet
template HeadLayer(nRows, nCols, nChannels, nFilters, kernelSize, strides) {
    // Hash of the input 
    signal input in_hash;
    // Input 
    signal input x[nRows][nCols][nChannels];
    var convLayerOutputRows = (nRows-kernelSize)\strides+1;
    var convLayerOutputCols = (nCols-kernelSize)\strides+1;
    var convLayerOutputDepth = nFilters;
    var scaleFactor = 10**16;
    signal activations[convLayerOutputRows][convLayerOutputCols][convLayerOutputDepth];
    signal output out;

    // 1. Verify that H(in) == in_hash
    component mimc_previous_activations = MimcHashMatrix3D(nRows, nCols, nChannels);
    mimc_previous_activations.matrix <== x;
    // in_hash === mimc_previous_activations.hash;
    log(mimc_previous_activations.hash);

    // Weights matrix
    var W[kernelSize][kernelSize][nChannels][nFilters] = [
      [[[0, 0]], [[0, 0]], [[0, 0]]],
      [[[0, 0]], [[0, 0]], [[0, 0]]],
      [[[0, 0]], [[0, 0]], [[0, 0]]]
    ];
    
    // Bias vector
    var b[nFilters] = [0, 0];

    // 2. Generate Convolutional Network Output, Relu elements of 3D Matrix, and 
    // place the output into a flattened activations vector
    component convLayer = Conv2D(nRows, nCols, nChannels, nFilters, kernelSize, strides);
    convLayer.in <== x;
    convLayer.weights <== W;
    convLayer.bias <== b;

    component divs[convLayerOutputRows][convLayerOutputCols][convLayerOutputDepth];
    component relu[convLayerOutputRows][convLayerOutputCols][convLayerOutputDepth];
    // Now Relu all of the elements in the 3D Matrix output of our Conv2D Layer
    // The Relu'd outputs are stored in a flattened activations vector
    for (var row = 0; row < convLayerOutputRows; row++) {
        for (var col = 0; col < convLayerOutputCols; col++) {
            for (var depth = 0; depth < convLayerOutputDepth; depth++) {
                relu[row][col][depth] = ReLU();
                relu[row][col][depth].in <== convLayer.out[row][col][depth];
                // Floor divide by the scale factor
                divs[row][col][depth] = Division(scaleFactor);
                divs[row][col][depth].dividend <== relu[row][col][depth].out;
                activations[row][col][depth] <== divs[row][col][depth].quotient;
                // activations[row][col][depth] <== relu[row][col][depth].out \ scaleFactor;
            }
        }
    }

    component mimc_hash_activations = MimcHashMatrix3D(convLayerOutputRows, convLayerOutputCols, convLayerOutputDepth);
    mimc_hash_activations.matrix <== activations;
    out <== mimc_hash_activations.hash;
}

component main { public [in_hash] } = HeadLayer(4 + 2, 4 + 2, 1, 2, 3, 1);
