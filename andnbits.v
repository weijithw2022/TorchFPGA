module AndNBits #(
    parameter BITS = 8
)(
    output [BITS-1:0] out,
    input [BITS-1:0] a,b
);
    genvar i; 
    generate
        for(i = 0; i < BITS; i = i + 1 ) begin : and_block
            and an(out[i], a[i], b[i]);
        end
    endgenerate
endmodule