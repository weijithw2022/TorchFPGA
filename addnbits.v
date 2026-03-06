module addNBits #(
    parameter BITS = 8
)(
    output [BITS-1:0] sum,
    output carryOut,
    input [BITS-1:0] a,b,
    input carryIn
);
    wire [BITS:0] carry; 

    assign carry[0] = carryIn; 
    assign carryOut = carry[BITS];
    genvar i; 
    generate
        for(i = 0; i < BITS; i = i + 1 ) begin : add_block
            if (i == 0) begin
                // First bit addition with carryIn
                FullAdder FA (
                    .a(a[i]),
                    .b(b[i]),
                    .carryIn(carryIn),
                    .sum(sum[i]),
                    .carryOut(carry[i])
                );
            end else begin
                // Subsequent bits addition with carry from previous bit
                FullAdder FA (
                    .a(a[i]),
                    .b(b[i]),
                    .carryIn(carry[i-1]),
                    .sum(sum[i]),
                    .carryOut(carry[i])
                );
            end
        end
    endgenerate

    // Final carry out is the carry from the last bit
    assign carryOut = carry[BITS-1];