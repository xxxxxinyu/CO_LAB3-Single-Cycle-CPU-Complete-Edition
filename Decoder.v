//109550085
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    instr_func_i,
    MemToReg_o,
    Jump_o,
    MemRead_o,
    MemWrite_o,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jal_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] instr_func_i;

output [2-1:0] MemToReg_o;
output [2-1:0] Jump_o;
output         MemRead_o;
output         MemWrite_o;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         Jal_o;
 
//Internal Signals
reg    [2-1:0] Jump_o;
reg            MemRead_o;
reg            MemWrite_o;
reg    [2-1:0] MemToReg_o;
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;
reg            Jal_o;

//Parameter
always @(*)
begin
    MemToReg_o = (instr_op_i == 6'b100011) ? 2'b01:2'b00;   // lw => 01, other => 00
    RegDst_o = (instr_op_i == 6'b000000) ? 2'b01:           // R-type => 01
               (instr_op_i == 6'b000011) ? 2'b10:2'b00;     // jal => 10
    // addi, R-type except jr, lw, jal
    RegWrite_o = ((instr_op_i == 6'b001000) || (instr_op_i == 6'b000000 && instr_func_i != 6'b001000) || (instr_op_i == 6'b100011) || (instr_op_i == 6'b000011)) ? 1'b1:1'b0;
    Branch_o = (instr_op_i == 6'b000100) ? 1'b1:1'b0;       // beq
    ALUSrc_o = (instr_op_i == 6'b001000 || instr_op_i == 6'b100011 || instr_op_i == 6'b101011) ? 1'b1:1'b0;     // addi lw sw
    MemWrite_o = (instr_op_i == 6'b101011) ? 1'b1:1'b0;     // sw
    MemRead_o = (instr_op_i == 6'b100011) ? 1'b1:1'b0;      // lw
    Jump_o = (instr_op_i == 6'b000010 || instr_op_i == 6'b000011) ? 2'b00:                 // jump, jal
              (instr_op_i == 6'b000000 && instr_func_i == 6'b001000) ? 2'b10 : 2'b01;      // jr
    Jal_o = (instr_op_i == 6'b000011) ? 1'b1:1'b0;          // jal
    
    ALU_op_o = (instr_op_i == 6'b000000) ? 3'b010:          // R-type
               (instr_op_i == 6'b001000 || instr_op_i == 6'b100011 || instr_op_i == 6'b101011) ? 3'b100:    // addi lw sw
               (instr_op_i == 6'b000100) ? 3'b011:          // beq
               (instr_op_i == 6'b001010) ? 3'b111: 3'b000;  // slti
end

//Main function

endmodule





                    
                    