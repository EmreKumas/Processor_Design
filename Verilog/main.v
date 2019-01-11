`timescale 1 ns/1 ns
module main();

reg Clock;

//Control_Unit
reg [3:0] opcode;
wire pcReadsignal;
wire instRead;
wire loadData;
wire regWrite;
wire pcWrite;
wire changePc;
wire [2:0] jumpSignal;
wire [1:0] aluControl;
wire dataMemRead;
wire memWrite;
wire jumpCondCheck;
wire compareSignal;

//Register_File
reg [15:0] data_to_write;
reg [3:0] register_to_write;
reg [3:0] output_a_selector;
reg [3:0] output_b_selector;
wire [15:0] output_a;
wire [15:0] output_b;

//ALU
reg [15:0] alu_register1;
reg [15:0] alu_register2;
reg [3:0] alu_imm;
wire [15:0] alu_result;

//Data Memory
reg [11:0] data_store_address;
reg [15:0] registor_to_data_memory;
wire [15:0] data_memory;

//Instruction_Memory
reg [11:0] instruction_address;
wire [15:0] instruction_memory;

//Comparator
reg [15:0] register_to_compare_a;
reg [15:0] register_to_compare_b;
wire zf, cf;

//Jump_Condition_Checker
reg jump_condition_result;
wire jump_condition_result_temp;

//PC
reg [15:0] program_counter;
reg first_mux_output;
reg [11:0] second_mux_output;

Control_Unit c_u(opcode, Clock, pcReadsignal, instRead, loadData, regWrite, pcWrite, changePc, 
				jumpSignal, aluControl, dataMemRead, memWrite, jumpCondCheck, compareSignal);

Data_Memory data_mem(data_store_address, registor_to_data_memory, memWrite, dataMemRead, Clock,data_memory);	
Instruction_Memory instruction_mem(instruction_address, instruction_memory);

Register_File register_file(data_to_write, regWrite, register_to_write, output_a_selector, output_b_selector, output_a, output_b, Clock);
ALU alu(alu_register1, alu_register2, alu_imm, aluControl, alu_result);
Comparator comparator(register_to_compare_a, register_to_compare_b, compareSignal, Clock, zf, cf);
Jump_Condition_Checker jump_condition_checker(jumpSignal, zf, cf, jumpCondCheck, jump_condition_result_temp);

initial begin
	Clock <= 1'b0;
	program_counter <= 1'b0;
end

always @* begin
	
	if(pcReadsignal == 1)
		instruction_address <= program_counter;
	
	if(loadData == 0)
		data_to_write <= data_memory;
	else
		data_to_write <= alu_result;
		
	opcode[0] <= instruction_memory[12];
	opcode[1] <= instruction_memory[13];
	opcode[2] <= instruction_memory[14];
	opcode[3] <= instruction_memory[15];
	
	register_to_write[0] <= instruction_memory[8];
	register_to_write[1] <= instruction_memory[9];
	register_to_write[2] <= instruction_memory[10];
	register_to_write[3] <= instruction_memory[11];
	
	if(~instruction_memory[12] & instruction_memory[13] & instruction_memory[14] & ~instruction_memory[15]) begin
		output_a_selector[0] <= instruction_memory[8];
		output_a_selector[1] <= instruction_memory[9];
		output_a_selector[2] <= instruction_memory[10];
		output_a_selector[3] <= instruction_memory[11];
	end
	else begin
		output_a_selector[0] <= instruction_memory[4];
		output_a_selector[1] <= instruction_memory[5];
		output_a_selector[2] <= instruction_memory[6];
		output_a_selector[3] <= instruction_memory[7];
	end
	
	output_b_selector[0] <= instruction_memory[0];
	output_b_selector[1] <= instruction_memory[1];
	output_b_selector[2] <= instruction_memory[2];
	output_b_selector[3] <= instruction_memory[3];
	
	alu_imm[0] <= instruction_memory[0];
	alu_imm[1] <= instruction_memory[1];
	alu_imm[2] <= instruction_memory[2];
	alu_imm[3] <= instruction_memory[3];

	data_store_address[0] <= instruction_memory[0];
	data_store_address[1] <= instruction_memory[1];
	data_store_address[2] <= instruction_memory[2];
	data_store_address[3] <= instruction_memory[3];
	data_store_address[4] <= instruction_memory[4];
	data_store_address[5] <= instruction_memory[5];
	data_store_address[6] <= instruction_memory[6];
	data_store_address[7] <= instruction_memory[7];
	data_store_address[8] <= 1'b0;
	data_store_address[9] <= 1'b0;
	data_store_address[10] <= 1'b0;
	data_store_address[11] <= 1'b0;
	
	jump_condition_result <= jump_condition_result_temp | ~instruction_memory[15];
	
	registor_to_data_memory <= output_a;
	alu_register1 <= output_a;
	alu_register2 <= output_b;
	
	if(changePc == 1)
		first_mux_output = jump_condition_result;
	else
		first_mux_output = 0;
		
	if(first_mux_output == 1)
		second_mux_output = instruction_memory[11:0];
	else
		second_mux_output = 12'h001;
	
end

always begin
	#15 Clock <= ~Clock;	
end

always @(posedge Clock) begin
	
	if(pcWrite == 1)
		program_counter <= second_mux_output + program_counter;
	
end

endmodule