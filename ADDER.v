module ADDER (
    input wire [31:0] In1,
    input wire [31:0] In2,
    output wire [31:0] Out
);
 assign Out=In1+In2;
endmodule