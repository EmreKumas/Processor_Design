module Data_Memory
	(
	 input reg [11:0] data_store_address,
	 input reg [15:0] register,
	 input reg mem_write,
	 input reg data_mem_read,
	 input Clock,
	 output reg [15:0] data_memory_readed
	);
	
	reg [15:0] memory [15:0];
	integer i;

	initial begin
	
		for(i = 0; i < 16; i = i + 1)
			memory[i] = 16'h0000;
	
		$readmemh("Data_Memory.txt", memory);
	end
	
	always @* begin
		
		if(data_mem_read == 1)
			data_memory_readed <= memory[data_store_address];
	end
	
	always @(posedge Clock) begin
		
		if(mem_write == 1)
			memory[data_store_address] <= register;
	end

endmodule