module partialMatrixMultiplier #(
    parameter BITS = 8,
    parameter SIZE = 4
)(
    input [BITS*SIZE-1:0] a ,
    input [BITS*SIZE-1:0] b ,
    output [BITS*SIZE*2 +SIZE/2-1:0] c [0:SIZE-1]
);
genvar i;
generate
    for(i = 0; i< SIZE; i = i+1) begin: mult_block
        wire [BITS*2-1:0] multResult;
        wire cout;
        multiplyNBits #(BITS*SIZE) mu(
            .out(multResult),
            .a(a[i*BITS +: BITS -1: i*BITS]),
            .b(b[i*BITS +: BITS -1: i*BITS]) // Replicate b[i] BITS*SIZE times to create a vector for AND operation
        );

        wire  [BITS*2 + i:0] addOut;

        if (i == 0) begin
            ADD_BITS #(BITS*2 + 1) add(
                .sum(addOut),
                .carryOut(cout),
                .a(mult_block[0].multResult), 
                .b(mult_block[1].multResult), 
                .carryIn(0)
            );
        end
        else begin
            ADD_BITS #(BITS*2 + i + 1) add(
                .sum(addOut),
                .carryOut(cout),
                .a(mult_block[i +1 ].multResult), 
                .b(add_block[i-1].cout, add_block[i-1].addOut), 
                .carryIn(0)
            );
        end
        
    end
endgenerate
assign c = {add_block[SIZE-2].cout, add_block[SIZE-2].addOut};
endmodule