module bin2LCD (out, data, show);
		output [8:0]out;
		input [3:0]data;
		input show;
		reg [8:0]out;
		
		always @ (*)
		begin
			if (show == 1'b0)
				out = 9'h120;
			else if ( data > 4'd9)
				out = data + 9'h157;
			else
				out = data + 9'h130;
		end
endmodule
