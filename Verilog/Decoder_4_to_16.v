module Decoder_4_to_16
	(
	 input reg [3:0] select_bits,
	 input reg enable_bit,
	 output reg [15:0] out
	);
	
	always @*
		case({enable_bit, select_bits})
			5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100, 5'b00101, 5'b00110,
				5'b00111, 5'b01000, 5'b01001, 5'b01010, 5'b01011, 5'b01100,
				5'b01101, 5'b01110, 5'b01111: out = 16'h0000;
			5'b10000: out = 16'h0001;
			5'b10001: out = 16'h0002;
			5'b10010: out = 16'h0004;
			5'b10011: out = 16'h0008;
			5'b10100: out = 16'h0010;
			5'b10101: out = 16'h0020;
			5'b10110: out = 16'h0040;
			5'b10111: out = 16'h0080;
			5'b11000: out = 16'h0100;
			5'b11001: out = 16'h0200;
			5'b11010: out = 16'h0400;
			5'b11011: out = 16'h0800;
			5'b11100: out = 16'h1000;
			5'b11101: out = 16'h2000;
			5'b11110: out = 16'h4000;
			5'b11111: out = 16'h8000;
		endcase
		
endmodule