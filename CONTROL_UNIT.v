module CONTROL_UNIT (
    input  wire [5:0] Opcode_Top,
    input  wire [5:0] Funct_Top,
    output wire      MemtoReg_Top,
    output wire       MemWrite_Top,
    output wire       Branch_Top,
    output wire       ALUSrc_Top,
    output wire       RegDst_Top,
    output wire       RegWrite_Top,
    output wire       Jump_Top,
    output wire [2:0] ALUControl_Top
);
wire [1:0] ALUOp_Top;

    ALU_DECODER u_ALU_DECODER(
    	.ALUOp      (ALUOp_Top  ),
        .Funct      (Funct_Top  ),
        .ALUControl (ALUControl_Top )
    );
    
    MAIN_DECODER u_MAIN_DECODER(
    	.Opcode   (Opcode_Top   ),
        .MemtoReg (MemtoReg_Top ),
        .MemWrite (MemWrite_Top ),
        .Branch   (Branch_Top   ),
        .ALUSrc   (ALUSrc_Top   ),
        .RegDst   (RegDst_Top   ),
        .RegWrite (RegWrite_Top ),
        .Jump     (Jump_Top     ),
        .ALUOp    (ALUOp_Top    )
    );
    

endmodule