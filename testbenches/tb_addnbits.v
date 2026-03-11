`timescale 1ns / 1ps

module tb_addNBits; 
    parameter BITS = 8;

    reg [BITS-1:0] a;
    reg [BITS-1:0] b;
    reg carryIn;

    wire [BITS-1:0] sum;
    wire carryOut;

    addNBits #(.BITS(BITS)) uut(
        .a(a),
        .b(b),
        .carryIn(carryIn),
        .sum(sum),
        .carryOut(carryOut)
    );

    initial begin
        $display("A        B        Cin | Sum      Cout");
        $display("--------------------------------------");

        a = 8'b00000000; b = 8'b00000000; carryIn = 0; #10;
        $display("%b %b  %b | %b  %b", a,b,carryIn,sum,carryOut);

        a = 8'b00000001; b = 8'b00000001; carryIn = 0; #10;
        $display("%b %b  %b | %b  %b", a,b,carryIn,sum,carryOut);

        a = 8'b00001111; b = 8'b00000001; carryIn = 0; #10;
        $display("%b %b  %b | %b  %b", a,b,carryIn,sum,carryOut);

        a = 8'b11110000; b = 8'b00001111; carryIn = 0; #10;
        $display("%b %b  %b | %b  %b", a,b,carryIn,sum,carryOut);

        a = 8'b11111111; b = 8'b00000001; carryIn = 0; #10;
        $display("%b %b  %b | %b  %b", a,b,carryIn,sum,carryOut);

        a = 8'b10101010; b = 8'b01010101; carryIn = 1; #10;
        $display("%b %b  %b | %b  %b", a,b,carryIn,sum,carryOut);

        $finish;
    end
    
endmodule

