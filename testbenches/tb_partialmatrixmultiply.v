`timescale 1ns/1ps

module tb_partialMatrixMultiplier;

    parameter BITS = 8;
    parameter SIZE = 4;

    reg  [BITS*SIZE-1:0]   a;
    reg  [BITS*SIZE-1:0]   b;
    wire [BITS*2+SIZE-2:0] c;

    partialMatrixMultiplier #(
        .BITS(BITS),
        .SIZE(SIZE)
    ) dut (
        .a(a),
        .b(b),
        .c(c)
    );

    // -------------------------------------------------------
    // Helper: pack 4 bytes into one flat vector
    //   pack(a3, a2, a1, a0) → { a3, a2, a1, a0 }
    //   a0 occupies bits [7:0], a3 bits [31:24]
    // -------------------------------------------------------
    function [BITS*SIZE-1:0] pack;
        input [BITS-1:0] e3, e2, e1, e0;
        begin
            pack = { e3, e2, e1, e0 };
        end
    endfunction

    integer expected;
    integer a0, a1, a2, a3;
    integer b0, b1, b2, b3;

    integer pass_count;
    integer fail_count;

    task run_test;
        input [BITS*SIZE-1:0] vec_a;
        input [BITS*SIZE-1:0] vec_b;
        input [31:0]          exp;
        input [63:0]          test_num;  
        begin
            a = vec_a;
            b = vec_b;
            #20;  

            $write("Test %0d: a=[%0d,%0d,%0d,%0d] b=[%0d,%0d,%0d,%0d] | expected=%0d got=%0d  ",
                test_num,
                a[3*BITS +: BITS], a[2*BITS +: BITS],
                a[1*BITS +: BITS], a[0*BITS +: BITS],
                b[3*BITS +: BITS], b[2*BITS +: BITS],
                b[1*BITS +: BITS], b[0*BITS +: BITS],
                exp, c);

            if (c == exp) begin
                $display("PASS ✓");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL ✗");
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("  partialMatrixMultiplier Testbench");
        $display("  BITS=%0d  SIZE=%0d", BITS, SIZE);
        $display("========================================");

        run_test(
            pack(8'd0, 8'd0, 8'd0, 8'd0),
            pack(8'd0, 8'd0, 8'd0, 8'd0),
            32'd0, 1
        );

        // --------------------------------------------------
        // Test 2: all ones → 1*1 + 1*1 + 1*1 + 1*1 = 4
        // --------------------------------------------------
        run_test(
            pack(8'd1, 8'd1, 8'd1, 8'd1),
            pack(8'd1, 8'd1, 8'd1, 8'd1),
            32'd4, 2
        );

        // --------------------------------------------------
        // Test 3: simple values
        //   a=[4,1,2,3]  b=[1,4,3,2]
        //   3*2 + 2*3 + 1*4 + 4*1 = 6+6+4+4 = 20
        // --------------------------------------------------
        run_test(
            pack(8'd4, 8'd1, 8'd2, 8'd3),
            pack(8'd1, 8'd4, 8'd3, 8'd2),
            32'd20, 3
        );

        // --------------------------------------------------
        // Test 4: one vector all zeros → dot product = 0
        // --------------------------------------------------
        run_test(
            pack(8'd5, 8'd10, 8'd3, 8'd7),
            pack(8'd0, 8'd0,  8'd0, 8'd0),
            32'd0, 4
        );

        // --------------------------------------------------
        // Test 5: identity-style
        //   a=[0,0,0,5]  b=[0,0,0,7]
        //   dot = 5*7 = 35
        // --------------------------------------------------
        run_test(
            pack(8'd0, 8'd0, 8'd0, 8'd5),
            pack(8'd0, 8'd0, 8'd0, 8'd7),
            32'd35, 5
        );

        // --------------------------------------------------
        // Test 6: max values → 255*255 * 4 = 260100
        // --------------------------------------------------
        run_test(
            pack(8'd255, 8'd255, 8'd255, 8'd255),
            pack(8'd255, 8'd255, 8'd255, 8'd255),
            32'd260100, 6
        );

        // --------------------------------------------------
        // Test 7: mixed values
        //   a=[10,20,30,40]  b=[1,2,3,4]
        //   40*4 + 30*3 + 20*2 + 10*1 = 160+90+40+10 = 300
        // --------------------------------------------------
        run_test(
            pack(8'd10, 8'd20, 8'd30, 8'd40),
            pack(8'd1,  8'd2,  8'd3,  8'd4),
            32'd300, 7
        );

        // --------------------------------------------------
        // Test 8: one element dominates
        //   a=[0,0,0,100]  b=[0,0,0,200]
        //   dot = 100*200 = 20000
        // --------------------------------------------------
        run_test(
            pack(8'd0, 8'd0, 8'd0, 8'd100),
            pack(8'd0, 8'd0, 8'd0, 8'd200),
            32'd20000, 8
        );

        // --------------------------------------------------
        // Summary
        // --------------------------------------------------
        $display("========================================");
        $display("  Results: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("========================================");

        $finish;
    end

endmodule