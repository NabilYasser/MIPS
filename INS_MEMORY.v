module INS_MEMORY #(parameter DataWidth =32, parameter Depth =100  ) (
    
    input wire [DataWidth-1:0] Addres,
    output reg  [DataWidth-1:0] REData
);

 reg [DataWidth-1:0] MEMORY [Depth-1:0];
 initial begin
     $readmemh ("factorial_machine_code.txt",MEMORY);
 end

always @(*) begin
    REData=MEMORY[Addres];
end

endmodule