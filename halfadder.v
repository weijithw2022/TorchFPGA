module halfAdder (
    input a,
    input b,
    output sum,
    output carry
);
    and AND (carry, a, b);
    xor XOR (sum, a, b);
endmodule