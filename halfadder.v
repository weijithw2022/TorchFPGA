module halfAdder (
    input a,
    input b,
    output sum,
    output carry
);
    and AND (Carry, a, b);
    xor XOR (Sum, a, b);
endmodule