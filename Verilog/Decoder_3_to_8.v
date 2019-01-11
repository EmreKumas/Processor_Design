module Decoder_3_to_8
	(
	 input reg [2:0] select_bits,
	 input reg enable_bit,
	 output reg [7:0] out
	);
	
	always @*
		case({enable_bit, select_bits})
			4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111: out = 8'h00;
			4'b1000: out = 8'h01;
			4'b1001: out = 8'h02;
			4'b1010: out = 8'h04;
			4'b1011: out = 8'h08;
			4'b1100: out = 8'h10;
			4'b1101: out = 8'h20;
			4'b1110: out = 8'h40;
			4'b1111: out = 8'h80;
		endcase
		
endmodule