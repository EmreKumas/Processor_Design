module ALU(
	input reg [15:0] a,
	input reg [15:0] b,
	input reg [3:0] Imm,
	input reg [1:0] Alu_Control,
	output reg [15:0] Result
	);
	
 reg [15:0] extended_Imm;
 
 integer i;
 
 always @* 
	begin 
		extended_Imm [0]= Imm[0];
		extended_Imm [1]= Imm[1];
		extended_Imm [2]= Imm[2];
		extended_Imm [3]= Imm[3];

		for( i=4 ; i<16; i=i+1 )
			extended_Imm[i] = Imm[3];
		
		if( Alu_Control[0] == 0 & Alu_Control[1] == 0)
			Result = a & b;
		else if(Alu_Control[0] == 0 & Alu_Control[1] == 1)
			Result = a & extended_Imm;
		else if(Alu_Control[0] == 1 & Alu_Control[1] == 0)
			Result = a + b;
		else begin
			if(Imm[3] == 1) begin
				extended_Imm = ~extended_Imm + 1;
				Result = a - extended_Imm;
			end
			else
				Result = a + extended_Imm;
		end
	end
endmodule 