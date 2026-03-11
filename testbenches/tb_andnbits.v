`timescale 1ns / 1ps

module tb_andnbits;
    parameter BITS = 8;

    reg [BITS-1:0] a;
    reg [BITS-1:0] b;

    wire [BITS-1:0] out;

    AndNBits #(.BITS(BITS)) uut(
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
       $display("A        B        | OUT");
        $display("------------------------");

        a = 8'b00000000; b = 8'b00000000; #10;
        $display("%b %b | %b", a, b, out);

        a = 8'b11111111; b = 8'b00000000; #10;
        $display("%b %b | %b", a, b, out);

        a = 8'b10101010; b = 8'b01010101; #10;
        $display("%b %b | %b", a, b, out);

        a = 8'b11110000; b = 8'b11001100; #10;
        $display("%b %b | %b", a, b, out);

        a = 8'b11111111; b = 8'b11111111; #10;
        $display("%b %b | %b", a, b, out);

        $finish;
    end
    
endmodule