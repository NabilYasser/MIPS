module MIPS #(
    parameter DataWidth=32, 
    parameter Inst_Left_Shifter_Data_Width = 26 , 
    parameter NumOfShifts=2 ,
    parameter Repeats = 16 ,
    parameter Reg_File_Address_DataWidth = 5
) (
    input wire clk_MIPS,
    input wire RST_MIPS,
    output wire [15:0] Test_value_MIPS
);

wire [DataWidth-1:0] Instr_MIPS;
wire [DataWidth-1:0] ReadData_Result_MIPS;
wire Branch_MIPS;
wire ALUSrc_MIPS;
wire RegDst_MIPS;
wire RegWrite_MIPS;
wire Jump_MIPS;
wire [2:0] ALUControl_MIPS;
wire [DataWidth-1:0] PC_MIPS;
wire [DataWidth-1:0] PC_MIPS_shifted;
wire [DataWidth-1:0] ALUOut_MIPS;
wire [DataWidth-1:0] WriteData_MIPS;

wire  MemWrite_MIPS;
wire MemtoReg_MIPS;
wire [DataWidth-1:0] ReadData_MIPS;


assign PC_MIPS_shifted=PC_MIPS>>2;
    
    DATA_PATH #(
        .DataWidth                    (DataWidth                    ),
        .Inst_Left_Shifter_Data_Width (Inst_Left_Shifter_Data_Width ),
        .NumOfShifts                  (NumOfShifts                  ),
        .Repeats                      (Repeats                      ),
        .Reg_File_Address_DataWidth   (Reg_File_Address_DataWidth   )
    )
    u_DATA_PATH(
    	.clk_Top         (clk_MIPS         ),
        .RST_Top         (RST_MIPS         ),
        .Instr_Top       (Instr_MIPS       ),
        .ReadData_Result (ReadData_Result_MIPS ),
        .Branch_Top      (Branch_MIPS      ),
        .ALUSrc_Top      (ALUSrc_MIPS      ),
        .RegDst_Top      (RegDst_MIPS      ),
        .RegWrite_Top    (RegWrite_MIPS    ),
        .Jump_Top        (Jump_MIPS        ),
        .ALUControl_Top  (ALUControl_MIPS  ),
        .PC_Top          (PC_MIPS          ), 
        .ALUOut_Top      (ALUOut_MIPS      ),
        .Reg_File_Read_Data_2   (WriteData_MIPS   )
    );


    CONTROL_UNIT u_CONTROL_UNIT(
    	.Opcode_Top     (Instr_MIPS[31:26]     ),
        .Funct_Top      (Instr_MIPS[5:0]      ),
        .MemtoReg_Top   (MemtoReg_MIPS   ), 
        .MemWrite_Top   (MemWrite_MIPS   ), 
        .Branch_Top     (Branch_MIPS     ),
        .ALUSrc_Top     (ALUSrc_MIPS     ),
        .RegDst_Top     (RegDst_MIPS     ),
        .RegWrite_Top   (RegWrite_MIPS   ),
        .Jump_Top       (Jump_MIPS       ),
        .ALUControl_Top (ALUControl_MIPS )
    );




    INS_MEMORY  u_INS_MEMORY(
    	.Addres (PC_MIPS_shifted ),
        .REData (Instr_MIPS )
    );
    

    MUX #(
        .DataWidth (DataWidth )
    )
    u_MUX_DATA_MEM(
    	.Sel (MemtoReg_MIPS ),
        .In1 (ALUOut_MIPS ),
        .In2 (ReadData_MIPS ),
        .Out (ReadData_Result_MIPS )
    );
    

    DATA_MEM u_DATA_MEM(
    	.Addres     (ALUOut_MIPS     ),
        .WRData     (WriteData_MIPS     ),
        .WREnable   (MemWrite_MIPS   ),
        .clk        (clk_MIPS        ),
        .RST        (RST_MIPS        ),
        .Test_value (Test_value_MIPS ),
        .REData     (ReadData_MIPS     )
    );
    


/*
    DATA_MEM u_DATA_MEM(
    	.Addres   (ALUOut_MIPS   ),
        .WRData   (WriteData_MIPS   ),
        .WREnable (MemWrite_MIPS ),
        .clk      (clk_MIPS      ),
        .RST      (RST_MIPS      ),
        .REData   (ReadData_MIPS   )
    );
    
    */





endmodule