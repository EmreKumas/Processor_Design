module Register_File
	(
	 input reg [15:0] data_to_write,
	 input reg regWrite,
	 input reg [3:0] register_to_write,
	 input reg [3:0] output_a_selector,
	 input reg [3:0] output_b_selector,
	 output reg [15:0] output_a,
	 output reg [15:0] output_b,
	 input Clock
	);
	
	reg [15:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11,
			   reg12, reg13, reg14, reg15, reg16;
	wire [15:0] decoded_value;
	integer i;
	
	Decoder_4_to_16 decoder(register_to_write, 1'b1, decoded_value);
	
	initial begin
		reg1 <= 0;
		reg2 <= 0;
		reg3 <= 0;
		reg4 <= 0;
		reg5 <= 0;
		reg6 <= 0;
		reg7 <= 0;
		reg8 <= 0;
		reg9 <= 0;
		reg10 <= 0;
		reg11 <= 0;
		reg12 <= 0;
		reg13 <= 0;
		reg14 <= 0;
		reg15 <= 0;
		reg16 <= 0;
	end
	
	always @(posedge Clock) begin
			
		if(decoded_value[0] & regWrite)
			reg1 <= data_to_write;
		else if(decoded_value[1] & regWrite)
			reg2 <= data_to_write;
		else if(decoded_value[2] & regWrite)
			reg3 <= data_to_write;
		else if(decoded_value[3] & regWrite)
			reg4 <= data_to_write;
		else if(decoded_value[4] & regWrite)
			reg5 <= data_to_write;
		else if(decoded_value[5] & regWrite)
			reg6 <= data_to_write;
		else if(decoded_value[6] & regWrite)
			reg7 <= data_to_write;
		else if(decoded_value[7] & regWrite)
			reg8 <= data_to_write;
		else if(decoded_value[8] & regWrite)
			reg9 <= data_to_write;
		else if(decoded_value[9] & regWrite)
			reg10 <= data_to_write;
		else if(decoded_value[10] & regWrite)
			reg11 <= data_to_write;
		else if(decoded_value[11] & regWrite)
			reg12 <= data_to_write;
		else if(decoded_value[12] & regWrite)
			reg13 <= data_to_write;
		else if(decoded_value[13] & regWrite)
			reg14 <= data_to_write;
		else if(decoded_value[14] & regWrite)
			reg15 <= data_to_write;
		else if(decoded_value[15] & regWrite)
			reg16 <= data_to_write;
		
	end
	
	wire [15:0] a, b;
	
	Mux_16 a_mux(reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11,
			   reg12, reg13, reg14, reg15, reg16, output_a_selector, a);
	Mux_16 b_mux(reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11,
			   reg12, reg13, reg14, reg15, reg16, output_b_selector, b);
	
	always @* begin
		output_a <= a;
		output_b <= b;
	end
	
endmodule