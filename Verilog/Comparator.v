module Comparator(
		input reg [15:0] a,
		input reg [15:0] b,
		input reg compareSignal,
		input Clock,
		output reg zf,cf
	);
	reg bigger,less,equal;

	initial begin 
		bigger = 0;
		less = 0;
		equal = 0;
	end
	
	always @*
		begin 
		if (a > b)
			bigger = 1;
		else if( a == b )
			equal = 1;
		else
			less = 1;
	end 
	
	always @(posedge Clock)
		begin
			zf = ~bigger & equal & ~less & compareSignal;
			cf = ~bigger & ~equal & less & compareSignal;
		end

endmodule	


			