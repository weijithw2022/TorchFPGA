`timescale 1ns/1ps

module tb_multiplnbits;
    parameter BITS = 8;
    reg  [BITS-1:0] a;
    reg  [BITS-1:0] b;
    wire [2*BITS-1:0] product;

    multiplyNBits #(BITS) uut (
        .a(a),
        .b(b),
        .product(product)
    );

    initial begin

        $display("A        B        | PRODUCT");
        $display("--------------------------------");

        a = 0; b = 0; #10;
        $display("%d * %d = %d", a, b, product);

        a = 3; b = 5; #10;
        $display("%d * %d = %d", a, b, product);

        a = 7; b = 9; #10;
        $display("%d * %d = %d", a, b, product);

        a = 15; b = 15; #10;
        $display("%d * %d = %d", a, b, product);

        a = 25; b = 10; #10;
        $display("%d * %d = %d", a, b, product);

        $finish;

    end
endmodule;