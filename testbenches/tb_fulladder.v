`timescale 1ns / 1ps

module tb_fulladder;
    reg a;
    reg b;
    reg carryIn;
    wire sum;
    wire carryOut;

    FullAdder uut(
        .a(a),
        .b(b),
        .carryIn(carryIn),
        .sum(sum),
        .carryOut(carryOut)
    );

    initial begin
        $display("A B CarryIn | Sum COut");
        $display("---------------------------");

        a = 0; b = 0; carryIn = 0; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 0; b = 0; carryIn = 1; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 0; b = 1; carryIn = 0; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 0; b = 1; carryIn = 1; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 1; b = 0; carryIn = 0; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 1; b = 0; carryIn = 1; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 1; b = 1; carryIn = 0; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        a = 1; b = 1; carryIn = 1; #10;
        $display("%b %b   %b     |  %b   %b", a, b, carryIn, sum, carryOut);

        $finish;

    end
    
endmodule