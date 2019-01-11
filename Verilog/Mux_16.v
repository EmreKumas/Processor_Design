module Mux_16(
	input reg [15:0] i1,
	input reg [15:0] i2,
	input reg [15:0] i3,
	input reg [15:0] i4,
	input reg [15:0] i5,
	input reg [15:0] i6,
	input reg [15:0] i7,
	input reg [15:0] i8,
	input reg [15:0] i9,
	input reg [15:0] i10,
	input reg [15:0] i11,
	input reg [15:0] i12,
	input reg [15:0] i13,
	input reg [15:0] i14,
	input reg [15:0] i15,
	input reg [15:0] i16,
	input reg [3:0] selector,
	output reg [15:0] o
	);
	
	always @* 
		case ({selector})
			4'h0: o = i1;
			4'h1: o = i2;
			4'h2: o = i3;
			4'h3: o = i4;
			4'h4: o = i5;
			4'h5: o = i6;
			4'h6: o = i7;
			4'h7: o = i8;
			4'h8: o = i9;
			4'h9: o = i10;
			4'ha: o = i11;
			4'hb: o = i12;
			4'hc: o = i13;
			4'hd: o = i14;
			4'he: o = i15;
			4'hf: o = i16;
		endcase
endmodule