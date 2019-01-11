module Instruction_Memory
	(
	 input reg [11:0] address,
	 output reg [15:0] instruction_readed
	);
	
	reg [15:0] memory [15:0];
	integer i;
	
	initial begin
	
		for(i = 0; i < 16; i = i + 1)
			memory[i] = 16'h0000;
	
		$readmemh("Instruction_Memory.txt", memory);
	end
	
	always @* begin
		instruction_readed <= memory[address];
	end

endmodule