//109550085
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_out;
wire [32-1:0] adder1_sum;
wire [32-1:0] adder2_sum;
wire [32-1:0] im_out;
wire [3-1:0] alu_op;
wire alu_src;
wire branch;
wire reg_write;
wire [2-1:0] reg_dst;
wire alu_zero;
wire [5-1:0] mux_write_reg_out;
wire [32-1:0] alu_result;
wire [32-1:0] RSdata_out;
wire [32-1:0] RTdata_out;
wire [32-1:0] sign_ext_out;
wire [32-1:0] mux_alusrc_out;
wire [4-1:0] alu_ctrl_out;
wire [32-1:0] shift_left_out;
wire [32-1:0] mux_pc_source;
wire [32-1:0] mux_pc_source_o1;
wire [3-1:0] func_op_i;
wire [2-1:0] MemToReg;
wire [2-1:0] Jump;
wire MemRead;
wire MemWrite;
wire [32-1:0] Data_Memory_out;
wire [32-1:0] mux_dm_o;
wire [32-1:0] jump_addr_o;
wire [32-1:0] mux_branch_o;
wire [32-1:0] mux_jal_out;
wire jal;

assign jump_addr_o[1:0] = 2'b00;
assign jump_addr_o[28-1:2] = im_out[26-1:0];
assign jump_addr_o[32-1:28] = adder1_sum[32-1:28];

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(mux_pc_source) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out),     
	    .sum_o(adder1_sum)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(im_out)    
	    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(im_out[20:16]),
        .data1_i(im_out[15:11]),
        .data2_i(32'd31),
        .select_i(reg_dst),
        .data_o(mux_write_reg_out)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(im_out[25:21]) ,  
        .RTaddr_i(im_out[20:16]) ,  
        .RDaddr_i(mux_write_reg_out) ,  
        .RDdata_i(mux_jal_out) , 
        .RegWrite_i (reg_write),
        .RSdata_o(RSdata_out) ,  
        .RTdata_o(RTdata_out)   
        );
	
Decoder Decoder(
        .instr_op_i(im_out[31:26]), 
        .instr_func_i(im_out[6-1:0]),
        .MemToReg_o(MemToReg),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),   
		.Branch_o(branch),
		.Jal_o(jal)   
	    );

ALU_Ctrl AC(
        .funct_i(im_out[5:0]),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_ctrl_out) 
        );
	
Sign_Extend SE(
        .data_i(im_out[15:0]),
        .data_o(sign_ext_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_out),
        .data1_i(sign_ext_out),
        .select_i(alu_src),
        .data_o(mux_alusrc_out)
        );	
		
ALU ALU(
        .src1_i(RSdata_out),
	    .src2_i(mux_alusrc_out),
	    .ctrl_i(alu_ctrl_out),
	    .result_o(alu_result),
		.zero_o(alu_zero)
	    );
	
Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(alu_result),
        .data_i(RTdata_out),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(Data_Memory_out)
	);
	
Adder Adder2(
        .src1_i(adder1_sum),     
	    .src2_i(shift_left_out),     
	    .sum_o(adder2_sum)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_ext_out),
        .data_o(shift_left_out)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Branch(
        .data0_i(adder1_sum),
        .data1_i(adder2_sum),
        .select_i(branch&alu_zero),
        .data_o(mux_pc_source_o1)
        );	
        
MUX_3to1 #(.size(32)) Mux_PC_Jump(
        .data0_i(jump_addr_o),
        .data1_i(mux_pc_source_o1),
        .data2_i(RSdata_out),
        .select_i(Jump),
        .data_o(mux_pc_source)
        ); 

MUX_3to1 #(.size(32)) Mux_DM(
        .data0_i(alu_result),
        .data1_i(Data_Memory_out),
        .data2_i(sign_ext_out),
        .select_i(MemToReg),
        .data_o(mux_dm_o)
        );
        
MUX_2to1 #(.size(32)) Mux_Jal(
        .data0_i(mux_dm_o),
        .data1_i(adder1_sum),
        .select_i(jal),
        .data_o(mux_jal_out)
        );        
        
endmodule
		  


