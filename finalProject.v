// The "general" layout of this file is taken from https://johnloomis.org/digitallab/lcdlab/lcdlab1/lcdlab1.html top level module.
module finalProject( // top level module
  input rst,
  input CLOCK_50,
  input decrypt,			//switch on DE2
  input ps2ck,ps2dt,		//keyboard clocks
  output inputComplete,
				//LCD Module 16X2
  output LCD_ON, 					//LCD Power ON/OFF
  output LCD_BLON,					//LCD Back Light ON/OFF
  output LCD_RW,					//LCD Read/Write Select, 0 = Write, 1 = Read
  output LCD_EN,					//LCD Enable
  output LCD_RS,					//LCD Command/Data Select, 0 = Command, 1 = Data
  inout [7:0] LCD_DATA				//LCD Data bus 8 bits
);

    								


	// Internal Logic
	
	wire [63:0]data;			                   
	wire [4:0]char_count_1;			// number of characters inputed
	wire [63:0]key;			                   
	wire [4:0]char_count_2;			// number of characters inputed
	wire [63:0] Output;
	reg [4:0]charTemp;
	wire refresh;
	
	wire [143:0]Line_1;
	wire [143:0]Line_2;
	wire [143:0]Line_3;
	
	
	// Instanciations 
	
	
	inputControl dataIn(CLOCK_50, rst, ps2ck, ps2dt, char_count_1, data, char_count_2, key, refresh, inputComplete);
	desEncryption d(data, key, decrypt, Output);
	LCD_Display u1(
				// Host Side
		.iCLK(CLOCK_50),
		.iRST_N(refresh),
		.Line_1((inputComplete ? Line_3 : Line_1)),
		.Line_2(Line_2),
				// LCD Side
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)
	);
	
	// LCD Control
	
	

	
	assign    LCD_ON   = 1'b1;
	assign    LCD_BLON = 1'b1;

	
	always@(*) begin
		if(inputComplete == 1'b1) begin
			charTemp = 5'd0; // remove second line
		end
		else
			charTemp = char_count_2;
	end
	
	
	
	// The following was taken from https://github.com/ZacharyZampa/ECE287_Project/blob/master/DES_Encryption_Hardware/ECE287_Project.v
	 generate
	 	genvar i;
	 	for(i = 0; i < 16; i = i+1) begin : generate_block_identifier
	 		bin2LCD dataBus(Line_1[143-9*i -: 9], data[63-4*i -:4], char_count_1 > i); // make each hex value accessible to LCD

	 		bin2LCD keyBus(Line_2[143-9*i -: 9], key[63-4*i -:4], charTemp > i);

			bin2LCD result(Line_3[143-9*i -: 9], Output[63-4*i -:4], 1'b1); // Custom 
	 	end
	 endgenerate


	 
	 
	 
	 

endmodule
