module PC #(parameter DataWidth =32) (
    input wire [DataWidth-1:0] PC_IN,
    input wire        clk ,
    input wire        RST ,
    output reg [DataWidth-1:0] PC_OUT
);

always @(posedge clk or negedge RST) begin
    if (!RST) begin
        PC_OUT<='b0;
    end
    else begin
        PC_OUT<=PC_IN;
    end
    
end
    
endmodule