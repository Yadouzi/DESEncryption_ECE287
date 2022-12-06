module inputControl(clk, rst, ps2ck, ps2dt, line1Count, data, line2Count, key, refresh, inputComplete);
	
	input ps2ck, ps2dt;
   input clk, rst;
   reg dataLock;
   output reg [63:0]data;
   output reg [63:0]key;
   output reg [4:0]line1Count; // how many char have been entered, max 16 hex, 8 ascii
   output reg [4:0]line2Count; // how many char have been entered, max 16 hex, 8 ascii
   output reg inputComplete;
	output refresh;
	wire [35:0]characters;
	wire backspace, delete, enter;
	reg [5:0]cursor;
	reg [5:0]cursor2;
	assign refresh = !enter & !backspace & !delete & rst & characters == 16'd0;
	
   // PS2 Keyboard Instantiation 
	ps2Keyboard keyInput(clk,ps2ck,ps2dt,characters,backspace,delete,enter);

	// FSM
	parameter WAIT = 4'd0,
           dataSet = 4'd1,
              SIZE = 4'd2,
          nextLine = 4'd3,
           RELEASE = 4'd4,
           POS_RST = 4'd5,
           POS_INC = 4'd6,
           POS_DEC = 4'd7,
              DONE = 4'd8,
             ERROR = 4'd9;

	
	reg [3:0] NS;
	reg [3:0] S;

    always@(posedge clk or negedge rst) begin
        if(rst == 1'b0) 
            S <= WAIT;
        else
            S <= NS;
    end

	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0)
		begin
			line1Count <= 5'd0;
            line2Count <= 5'd0;
			cursor <= 6'd63;
			cursor2 <= 6'd63;
			data <= 64'd0;
            key <= 64'd0;
            dataLock <= 1'b0;
            inputComplete <= 1'b0;
		end
        else
        begin
            case(S)
                dataSet: begin
                    if(dataLock == 1'd0)
						  // The following case statements are similar to thoes in the link below, but the FSM to control input data is custom.
						  // https://github.com/ZacharyZampa/ECE287_Project/blob/master/DES_Encryption_Hardware/Bit_Input.v
                        case(characters)
                            16'b0000000000000001: data[cursor-:4] <= 4'd0;
                            16'b0000000000000010: data[cursor-:4] <= 4'd1;
                            16'b0000000000000100: data[cursor-:4] <= 4'd2;
                            16'b0000000000001000: data[cursor-:4] <= 4'd3;
                            16'b0000000000010000: data[cursor-:4] <= 4'd4;
                            16'b0000000000100000: data[cursor-:4] <= 4'd5;
                            16'b0000000001000000: data[cursor-:4] <= 4'd6;
                            16'b0000000010000000: data[cursor-:4] <= 4'd7;
                            16'b0000000100000000: data[cursor-:4] <= 4'd8;
                            16'b0000001000000000: data[cursor-:4] <= 4'd9;
                            16'b0000010000000000: data[cursor-:4] <= 4'd10;
                            16'b0000100000000000: data[cursor-:4] <= 4'd11;
                            16'b0001000000000000: data[cursor-:4] <= 4'd12;
                            16'b0010000000000000: data[cursor-:4] <= 4'd13;
                            16'b0100000000000000: data[cursor-:4] <= 4'd14;
                            16'b1000000000000000: data[cursor-:4] <= 4'd15;
                        endcase
                    else
                        case(characters)
                            16'b0000000000000001: key[cursor2-:4] <= 4'd0;
                            16'b0000000000000010: key[cursor2-:4] <= 4'd1;
                            16'b0000000000000100: key[cursor2-:4] <= 4'd2;
                            16'b0000000000001000: key[cursor2-:4] <= 4'd3;
                            16'b0000000000010000: key[cursor2-:4] <= 4'd4;
                            16'b0000000000100000: key[cursor2-:4] <= 4'd5;
                            16'b0000000001000000: key[cursor2-:4] <= 4'd6;
                            16'b0000000010000000: key[cursor2-:4] <= 4'd7;
                            16'b0000000100000000: key[cursor2-:4] <= 4'd8;
                            16'b0000001000000000: key[cursor2-:4] <= 4'd9;
                            16'b0000010000000000: key[cursor2-:4] <= 4'd10;
                            16'b0000100000000000: key[cursor2-:4] <= 4'd11;
                            16'b0001000000000000: key[cursor2-:4] <= 4'd12;
                            16'b0010000000000000: key[cursor2-:4] <= 4'd13;
                            16'b0100000000000000: key[cursor2-:4] <= 4'd14;
                            16'b1000000000000000: key[cursor2-:4] <= 4'd15;
                        endcase
                end
                POS_INC: begin
                    if(dataLock == 1'd0) begin
                        line1Count <= line1Count + 5'd1;
                        cursor <= cursor - 6'd4;
                        end
                    else begin
                        line2Count <= line2Count + 5'd1;
                        cursor2 <= cursor2 - 6'd4;
                        end
                end
                POS_DEC: begin
                    if(dataLock == 1'd0 && cursor != 6'd63) begin
                        line1Count <= line1Count - 5'd1;
                        cursor <= cursor + 6'd4;
                        end
                    else if (cursor2 != 6'd63) begin
                        line2Count <= line2Count - 5'd1;
                        cursor2 <= cursor2 + 6'd4;
                        end
                    else begin end
                end
                POS_RST: begin
                    if(dataLock == 1'd0) begin
                        line1Count <= 5'd0;
                        cursor <= 6'd63;
                        end
                    else begin
                        line2Count <= 5'd0;
                        cursor2 <= 6'd63;
                        end
                end
               nextLine: begin
                    if (enter && dataLock == 1'b0)
                        dataLock <= 1'b1;
                    else
                        begin end
                end
                    DONE: inputComplete <= 1'b1;
				 
            endcase
        end
    end

    always@(*) begin
        case(S)
            WAIT: begin
                if (backspace)
					NS = POS_DEC;
				else if (delete)
					NS = POS_RST;
				else if (characters != 16'b0) // wait until press
					NS = dataSet;
				else
					NS = WAIT;
            end
         dataSet: NS = POS_INC;
            SIZE: begin
                if (line1Count != 5'd16 && dataLock == 1'd0) // 16 chars typed and collecting data
					NS = WAIT;
				else if (line1Count == 5'd16 && dataLock == 1'd0)
					NS = nextLine;
                else if (line2Count != 5'd16 && dataLock == 1'd1) //collecting key
                    NS = WAIT;
                else if (line2Count == 5'd16 && dataLock == 1'd1)
                    NS = nextLine;
            end
         RELEASE: begin
                if (characters != 16'b0 || delete || backspace || enter)
                    NS = RELEASE;
                else
                    NS = SIZE;
         end
        nextLine: begin
                if (backspace)
                    NS = POS_DEC;
                else if (delete)
                    NS = POS_RST;
                else if (enter && dataLock == 1'd0)
                    NS = WAIT;
                else if (enter && dataLock == 1'd1)
                    NS = DONE;
					 else
						  NS = nextLine;
        end
         POS_INC: NS = RELEASE;
         POS_DEC: NS = RELEASE;
         POS_RST: NS = RELEASE;
			default: NS = ERROR;
        endcase
    end
    
endmodule
        