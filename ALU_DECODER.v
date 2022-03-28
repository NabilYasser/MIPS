module ALU_DECODER (
    input wire [1:0] ALUOp,
    input wire [5:0] Funct,
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00:begin
                ALUControl=3'b010;
            end 

             2'b01:begin
                ALUControl=3'b100;
            end 

             2'b10:begin
                case (Funct)
                    6'b100000:begin
                        ALUControl=3'b010;
                    end

                    6'b100010:begin
                        ALUControl=3'b100;
                    end  

                     6'b101010:begin
                        ALUControl=3'b110;
                    end

                     6'b011100:begin
                        ALUControl=3'b101;
                    end

                    default: ALUControl=3'b010;
                endcase
            end 
            default: begin
                ALUControl=3'b010;
            end
        endcase
        
    end
endmodule