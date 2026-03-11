module partialMatrixMultiplier #(
    parameter BITS = 8,
    parameter SIZE = 4
)(
    input [BITS*SIZE-1:0] a ,
    input [BITS*SIZE-1:0] b ,
    // output [BITS*SIZE*2 +SIZE/2-1:0] c [0:SIZE-1]
    output [BITS*2 + SIZE - 2:0] c   // BITS*2 + SIZE - 1 bits total

);
genvar i;
generate 
    for(i = 0; i< SIZE; i = i+1) begin: mult_block
        wire [BITS*2-1:0] product;
        wire cout;
        multiplyNBits #(BITS*SIZE) mu(
            .product(product),
            //.a(a[i*BITS +: BITS -1: i*BITS]),
            .a(a[i*BITS +: BITS]),
            //.b(b[i*BITS +: BITS -1: i*BITS]) // Replicate b[i] BITS*SIZE times to create a vector for AND operation
            .b(b[i*BITS +: BITS])
        );
    end
endgenerate

genvar j;
generate
    for (j =0; j < SIZE - 1; j = j + 1) begin: acc_block

        localparam W = BITS*2 + j + 1;
        wire [W-1:0] sum;
        wire cout;

        // wire  [BITS*2 + j:0] addOut;

        if (j == 0) begin : seed
            addNBits #(W) add(
                .sum(sum),
                .carryOut(cout),
                .a({1'b0, mult_block[0].product}), 
                // .a(mult_block[0].product), 
                .b({mult_block[1].product, 1'b0}),
                // .b(mult_block[1].product), 
                .carryIn(0)
            );
        end
        else begin : accumulate
            addNBits #(W) add(
                .sum(sum),
                .carryOut(cout),
                .a({1'b0, acc_block[j -1 ].sum}), 
                .b({{(j+1){1'b0}}, mult_block[j+1].product}), 
                .carryIn(0)
            );
        end
        
    end
endgenerate
assign c = acc_block[SIZE - 2].sum;
endmodule