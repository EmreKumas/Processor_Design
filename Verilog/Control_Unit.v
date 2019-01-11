module Control_Unit(
		input reg [3:0] opcode,
		input Clock,
		output reg pcReadsignal,
		output reg instRead,
		output reg loadData,
		output reg regWrite,
		output reg pcWrite,
		output reg changePc,
		output reg [2:0] jumpSignal,
		output reg [1:0] aluControl,
		output reg dataMemRead,
		output reg memWrite,
		output reg jumpCondCheck,
		output reg compareSignal
	);
	
	reg [2:0] state,stateNext;
	reg changePcReg;
	
	initial 
		begin
		state <= 3'b000;
		stateNext <= 3'b000;
		pcReadsignal <= 0;
		instRead <= 0;
		loadData <= 0;
		regWrite <= 0;
		pcWrite <= 0;
		changePc <= 0;
		jumpSignal <= 0;
		aluControl <= 0;
		dataMemRead <= 0;
		memWrite <= 0;
		jumpCondCheck <= 0;
		compareSignal <= 0;
		end
	
	always @(state, opcode)
		begin
			pcReadsignal <= ((~state[0]) & (~state[1]) & (~state[2]));
			instRead <= (state[0] & ~state[1] & ~state[2]);
			loadData <= (~state[0] & state[1] & ~state[2] & ~opcode[2] & ~opcode[3]);
			regWrite <= (~state[0] & state[1] & ~state[2] & ~opcode[2] & ~opcode[3]) | (~state[0] & state[1] & ~state[2] & opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3]);
			pcWrite <= state[2];
			changePcReg <= (state[0] & state[1] & ~state[2] & opcode[0] & opcode[1] & opcode[2] & ~opcode[3]) | (state[0] & state[1] & ~state[2] & opcode[3]);
			jumpSignal[0] <= opcode[0] ;  jumpSignal[1] <= opcode[1] ;  jumpSignal[2] <= opcode[2] ; 
			aluControl[0] <= opcode[0] ;  aluControl[1] <= opcode[1] ;
			dataMemRead <= (~state[0] & state[1] & ~state[2] & opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3]);
			memWrite <= (~state[0] & state[1] & ~state[2] & ~opcode[0] & opcode[1] & opcode[2] & ~opcode[3]);
			jumpCondCheck <= opcode[3];
			compareSignal <= (~state[0] & state[1] & ~state[2] & ~opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3]);
		
			stateNext[0] <= (~state[0] & ~state[1] & ~state[2]) | (~state[0] & state[1] & ~state[2]);
			stateNext[1] <= (state[0] & ~state[1] & ~state[2])  | (~state[0] & state[1] & ~state[2]);
			stateNext[2] <= (state[0] & state[1] & ~state[2]);
		end
		
	always @(posedge Clock) 
		begin
			state <= stateNext;
			changePc <= changePcReg;
		end
endmodule