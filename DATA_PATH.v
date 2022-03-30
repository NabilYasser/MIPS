module DATA_PATH #(parameter DataWidth=32, parameter Inst_Left_Shifter_Data_Width = 26 , parameter NumOfShifts=2 ,parameter Repeats = 16 ,parameter Reg_File_Address_DataWidth = 5,parameter Adder_Value = 4 ) (
    input wire clk_Top,
    input wire RST_Top,
    input wire [31:0] Instr_Top,
    input wire [31:0] ReadData_Result,

    input wire       Branch_Top,
    input wire       ALUSrc_Top,
    input wire       RegDst_Top,
    input wire       RegWrite_Top,
    input wire       Jump_Top,
    input wire [2:0] ALUControl_Top,

    output wire [31:0] PC_Top,
    output wire [31:0] ALUOut_Top,
    output wire [31:0] Reg_File_Read_Data_2
);

wire [DataWidth-1:0] PC_IN_Top;
wire [DataWidth-1:0] PC_Pluse_4;
wire PCSrc;
wire [DataWidth-1:0] PCBranch;
wire [DataWidth-1:0] MUX_LEFT_PC_out;
wire [27:0] PCJump; 
wire [DataWidth-1:0] SignImm_Top;
wire [DataWidth-1:0] SignImm_Shifter_Top;
wire Zero_Flag_Top; 
//wire [2:0] Adder_Value;  // *?



wire [DataWidth-1:0] Reg_File_Read_Data_1;
wire [4:0] Reg_File_Write_Address;



wire [DataWidth-1:0] SrcB;


assign PCSrc= Zero_Flag_Top & Branch_Top;
//assign Adder_Value=3'b100;

//* -------------------------------------------------------------------------- */
//*                                 PC Section                                 */
//*                        Inputs: Jump , Instru
//*                        Internal: SignImm_Top , SignImm_Shifter_Top,PCJump, PC_IN_Top, PC_Pluse_4,
//*                                  PCSrc, PCBranch, MUX2_LEFT_PC, Zero_Flag_Top
//*                        Outputs: PC_Top 
//* -------------------------------------------------------------------------- */

//This MUX is at the far left of PC reg
MUX #(
    .DataWidth (DataWidth )
)
u_MUX2_LEFT_PC(
    .Sel (PCSrc ),
    .In1 (PC_Pluse_4 ),
    .In2 (PCBranch ), 
    .Out (MUX_LEFT_PC_out )
);

//This MUX is at left of PC reg
MUX #(
    .DataWidth (DataWidth )
)
u_MUX_LEFT_PC(
    .Sel (Jump_Top ),
    .In1 (MUX_LEFT_PC_out ),
    .In2 ({PC_Pluse_4[31:28] ,PCJump} ),
    .Out (PC_IN_Top )
);

//Left Shifter for the PC reg
LEFT_SHIFTER #(
    .NumOfShifts     (NumOfShifts     ),
    .InputDataWidth  (Inst_Left_Shifter_Data_Width  ),
    .OutputDataWidth (28 )
)
u_LEFT_SHIFTER(
    .In  (Instr_Top[25:0]  ),
    .Out (PCJump )
);




//* -------------------------------------------------------------------------- */
//*           Sign extend Section (Sign Extend , Shifter , Adder )             */
//*           Inputs: Instr[15:0]                                              */
//*           Internal: SignImm_Top ,SignImm_Shifter_Top                       */
//*           Outputs: PCBranch                                                */
//* -------------------------------------------------------------------------- */

//Sign extender
SIGN_EXTEND #(
    .Repeat (Repeats )
)
u_SIGN_EXTEND(
    .Inst    (Instr_Top[15:0]),
    .Signimm (SignImm_Top )
);
//Sign Extend Shifter
LEFT_SHIFTER #(
    .NumOfShifts     (NumOfShifts     ),
    .InputDataWidth  (DataWidth  ),
    .OutputDataWidth (DataWidth )
)
u_LEFT_SHIFTER_SignImm(
    .In  (SignImm_Top  ),
    .Out (SignImm_Shifter_Top )
);
//Sign Extend Adder
ADDER u_ADDER_SignImm(
    .In1 (SignImm_Shifter_Top ),
    .In2 (PC_Pluse_4 ),
    .Out (PCBranch )
);




//Adder that increment PC by 4
ADDER u_ADDER(
    .In1 (PC_Top ),
    .In2 (Adder_Value), // *!
    .Out (PC_Pluse_4 )
);

//PC reg
PC  u_PC(
    .PC_IN  (PC_IN_Top  ),
    .clk    (clk_Top    ),
    .RST    (RST_Top    ),
    .PC_OUT (PC_Top )
);
    

//* -------------------------------------------------------------------------- */
//*           Register file Section           */
//*           Inputs: ReadData_Result                                          */
//*           Outputs: Reg_File_Read_Data_1  ,Reg_File_Read_Data_2                                             
//* -------------------------------------------------------------------------- */


MUX #(
    .DataWidth (Reg_File_Address_DataWidth )
)
u_MUX_Reg_File(
    .Sel (RegDst_Top ),
    .In1 (Instr_Top[20:16] ),
    .In2 (Instr_Top[15:11] ),
    .Out (Reg_File_Write_Address )
);


REG_FILE u_REG_FILE(
    .A1  (Instr_Top[25:21]  ),
    .A2  (Instr_Top[20:16]  ),
    .A3  (Reg_File_Write_Address  ),
    .WD3 (ReadData_Result ),
    .WE3 (RegWrite_Top ),
    .clk (clk_Top ),
    .RST (RST_Top ),
    .RD1 (Reg_File_Read_Data_1 ),
    .RD2 (Reg_File_Read_Data_2 )
);




//* -------------------------------------------------------------------------- */
//*           ALU Section           */
//*           Inputs: Reg_File_Read_Data_1   ,Reg_File_Read_Data_2                                    
//*           Outputs: ALUOut_Top  ,Zero_Flag_Top                                             
//* -------------------------------------------------------------------------- */

MUX #(
    .DataWidth (DataWidth )
)
u_MUX_ALU(
    .Sel (ALUSrc_Top ),
    .In1 (Reg_File_Read_Data_2 ),
    .In2 (SignImm_Top ),
    .Out (SrcB )
);


ALU u_ALU(
    .SrcA       (Reg_File_Read_Data_1       ),
    .SrcB       (SrcB       ),
    .ALUControl (ALUControl_Top ),
    .ALUResult  (ALUOut_Top  ),
    .ZeroFlag   (Zero_Flag_Top   )
);


endmodule