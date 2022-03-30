module DATA_MEM #(
    parameter DataWidth =32, parameter Depth =100 
) (
    input wire [DataWidth-1:0] Addres,
    input wire [DataWidth-1:0] WRData,
    input wire                 WREnable,
    input wire                 clk,
    input wire                 RST,
    output reg [15:0]         Test_value,
    output reg [DataWidth-1:0] REData
);
    reg [DataWidth-1:0] Data_Memory [0:Depth-1];
    integer  i;

    always @(*) begin
    REData=Data_Memory[Addres];
    end

    always @(*) begin
        Test_value=Data_Memory[32'h0];
    end
    
always @(posedge clk or negedge RST) begin
    if (!RST) begin
        for (i =0 ; i < Depth ;i=i+1 ) begin
           Data_Memory[i]<='b0; 
        end
    end else if (WREnable==1) begin
         Data_Memory[Addres]<=WRData;
        
    end 
end

endmodule