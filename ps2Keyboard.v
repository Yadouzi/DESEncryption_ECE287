// resource: https://github.com/alecamaracm/Verilog-Game-Engine-with-PowerPoint-designer/blob/master/VerilogExample/keyboard.v
module ps2Keyboard(CLOCK,ps2ck,ps2dt,characters,keyBackspace,delete,enter);

	inout ps2ck,ps2dt;	
	
	output reg [15:0]characters;
	output reg keyBackspace, delete, enter;
	input CLOCK;
	reg releasex;
	reg releaseCK;
	reg [3:0]position;
	reg [5:0]skipCycles;	
	reg [2:0]e0;
	reg [55:0]nonActivity; //On a timeout, the data bytes reset.
	wire[7:0]ps2_data;
	reg	[7:0]last_ps2_data;
	wire ps2_newData;
	mouse_Inner_controller innerMouse (   //Don't touch anything in this declaration. It deals with the data adquisition and basic commands to the mouse.
	.CLOCK_50			(CLOCK),
	.reset				(1'b0),
	.PS2_CLK			(ps2ck),
 	.PS2_DAT			(ps2dt),
	.received_data		(ps2_data),
	.received_data_en	(ps2_newData)
	);
	always @(posedge ps2_newData)
	begin
				case (ps2_data)
					8'hF0: 
					begin //releasex will be 1 when the key has been released.
						releasex=1'b1;
						releaseCK=1'b0;		
					end
					8'hE0:
					begin
						e0=3'd3;
					end
				endcase
				if(e0<=0) //Certain keys have a pre-code
				begin
					case (ps2_data)						
						8'h45: characters[0]<=!releasex;  // 0
						8'h16: characters[1]<=!releasex;  // 1
						8'h1E: characters[2]<=!releasex;  // 2
						8'h26: characters[3]<=!releasex;  // 3
						8'h25: characters[4]<=!releasex;  // 4
						8'h2E: characters[5]<=!releasex;  // 5
						8'h36: characters[6]<=!releasex;  // 6
						8'h3D: characters[7]<=!releasex;  // 7
						8'h3E: characters[8]<=!releasex;  // 8
						8'h46: characters[9]<=!releasex;  // 9
						8'h1C: characters[10]<=!releasex; // a
						8'h32: characters[11]<=!releasex; // b
						8'h21: characters[12]<=!releasex; // c
						8'h23: characters[13]<=!releasex; // d
						8'h24: characters[14]<=!releasex; // e
						8'h2B: characters[15]<=!releasex; // f
						8'h5A: enter<=!releasex;		  // enter
						8'h66: keyBackspace<=!releasex;   // <-
					endcase
				end
				else if(e0>0)
					if (ps2_data == 8'h71)
						delete<=!releasex; // delete

			if(releaseCK==1'b1)
			begin
				releasex=0;
				releaseCK=0;
			end
			else
			begin
				if(releasex==1'b1)
				begin
					releaseCK=1'b1;
				end
			end
			
			if(e0>3'b0)
			begin
				e0=e0-3'b1;			
			end
	end
endmodule
