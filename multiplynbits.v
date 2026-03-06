module multiplyNBits #(
    parameter BITS = 8
)(
    output [2*BITS-1:0] product,
    input [BITS-1:0] a, b
);

genvar i;
generate
    for (i =0; i<BITS; i = i + 1)begin: and_block
        wire [BITS-1:0] andResult;
        AndNBits #(BITS) an(
            .out(andResult),
            .a(a),
            .b({BITS{b[i]}}) // Replicate b[i] BITS times to create a vector for AND operation
        );
    end

    for (i = 0; i < BITS - 1 ; i = i + 1) begin: add_block
        wire [BITS+i:0] addOut;
        wire cout; 

        if (i == 0) begin
            ADD_BITS #(BITS + 1) add(
                .sum(addOut),
                .carryOut(cout),
                .a(and_block[0].andResult), 
                .b({and_block[1].andResult, 1'b0}), 
                .carryIn(0)
            );
        end
        else begin
            ADD_BITS #(BITS + i + 1) add(
                .sum(addOut),
                .carryOut(cout),
                .a({add_block[i-1].cout , add_block[i-1].addOut}), 
                .b({and_block[i+1].andResult, {i +1{1'b0}}}), 
                .carryIn(0)
            );
        end
    end
endgenerate

assign product = {add_block[BITS-2].cout, add_block[BITS-2].addOut}; 
    
endmodule