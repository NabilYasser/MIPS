module MUX #(
    parameter DataWidth=32

) (
    input wire                 Sel,
    input wire [DataWidth-1:0] In1,
    input wire [DataWidth-1:0] In2,
    output reg [DataWidth-1:0] Out
);

  always @(*) begin
      if (!Sel) begin
          Out=In1;
      end else begin
          Out=In2;
      end
  end  
endmodule