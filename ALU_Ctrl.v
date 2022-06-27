//109550085
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*)
begin
    ALUCtrl_o = (ALUOp_i == 3'b010 && funct_i == 6'b100000) ? 4'b0010:    // add 2
                (ALUOp_i == 3'b010 && funct_i == 6'b100010) ? 4'b0110:    // sub 6
                (ALUOp_i == 3'b010 && funct_i == 6'b100100) ? 4'b0000:    // and 0
                (ALUOp_i == 3'b010 && funct_i == 6'b100101) ? 4'b0001:    // or 1
                (ALUOp_i == 3'b010 && funct_i == 6'b101010) ? 4'b0101:    // slt 5
                (ALUOp_i == 3'b100) ? 4'b0010:                            // addi  2
                (ALUOp_i == 3'b011) ? 4'b0100:                            // beq 4
                (ALUOp_i == 3'b111) ? 4'b0101: 4'b0000;                       // slti 5 

end
endmodule     





                    
                    