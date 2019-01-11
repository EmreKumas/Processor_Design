module Jump_Condition_Checker
	(
	 input reg [2:0] jump_signal,
	 input reg zf, cf, jumpCondCheck,
	 output reg jump_condition_result
	);
	
	wire [7:0] decoder_result;
	reg je, ja, jb, jbe, jae;
	
	Decoder_3_to_8 decoder(jump_signal, 1'b1, decoder_result);
	
	always @*
	begin
		je = (zf & ~cf) & decoder_result[0] & jumpCondCheck;
		ja = (~zf & ~cf) & decoder_result[1] & jumpCondCheck;
		jb = (~zf & cf) & decoder_result[2] & jumpCondCheck;
		jbe = ((~zf & cf) | (zf & ~cf)) & decoder_result[3] & jumpCondCheck;
		jae = ((~zf & ~cf) | (zf & ~cf)) & decoder_result[4] & jumpCondCheck;
		jump_condition_result = je | ja | jb | jbe | jae;
	end
	
endmodule