module INS_MEMORY #(parameter DataWidth =32, parameter Depth =100  ) (
    input wire [DataWidth-1:0] WRData,
    input wire [DataWidth-1:0] Addres,
    input wire                 WREnable,
    input wire                 clk,
    input wire                 RST,
    output reg  [DataWidth-1:0] REData
);

 reg [DataWidth-1:0] MEMORY [Depth-1:0];
 integer i;

always @(posedge clk or negedge RST) begin
    if (!RST) begin
        for (i =0 ; i < Depth ;i=i+1 ) begin
           MEMORY[i]<='b0; // *! Should be a seed
        end
    end else if (WREnable==1) begin
         MEMORY[Addres]<=WRData;
        
    end 
end

always @(*) begin
    REData=MEMORY[Addres];
end

endmodule