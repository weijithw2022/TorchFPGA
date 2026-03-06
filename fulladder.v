module FullAdder (
    input a,
    input b,
    input carryIn,
    output sum,
    output carryOut
);
    wire sumHalf1, carryHalf1, carryHalf2;

    // First half adder
    halfAdder HA1 (
        .a(a),
        .b(b),
        .sum(sumHalf1),
        .carry(carryHalf1)
    );

    // Second half adder
    halfAdder HA2 (
        .a(sumHalf1),
        .b(carryIn),
        .sum(sum),
        .carry(carryHalf2)
    );

    // Carry out is the OR of the two carry outputs
    or OR (carryOut, carryHalf1, carryHalf2);
endmodule