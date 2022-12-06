module dataInput(clk, rst, ps2ck, ps2dt, char_count_1, data, char_count_2, key, refresh, inputComplete);
	
    //clocks
	input ps2ck, ps2dt;
    input clk, rst;
    //data
    reg dataLock;
    output reg [63:0]data;
    output reg [63:0]key;
    reg [5:0]cursor;
	 reg [5:0]cursor2;
    output reg [4:0]char_count_1; // how many char have been entered, max 16 hex, 8 ascii
    output reg [4:0]char_count_2; // how many char have been entered, max 16 hex, 8 ascii
    output reg inputComplete;
	output refresh;
	// keyboard vars
	wire [35:0]characters;
	wire keyBackspace, delete, enter;

	assign refresh = !keyBackspace & !delete & rst & characters == 16'd0;
	
    // PS2 Keyboard Instantiation 
	ps2Keyboard keyInput(clk,ps2ck,ps2dt,characters,keyBackspace,delete,enter); // TO DO: add "enter" and "space" implementation

	// FSM
	parameter WAIT = 4'd0,
            KYB2HEX = 4'd1,
            NEXT_CHAR = 4'd2,
            FULL_BUFF = 4'd3, // data
            DELETE = 4'd4,
            BACKSPACE_HELD = 4'd5,
            KYB_HELD = 4'd6,
            CRSR_INC = 4'd7,
            CRSR_EDGE = 4'd8,
            CRSR_DEC = 4'd9,
            KEY_INPUT = 4'd10,
            FINAL_BUFF = 4'd11, // key
            DONE = 4'd14,
            ERROR = 4'd15;

	
	reg [3:0] NS;
	reg [3:0] S;

    // user input fsm from keyboard


    always@(posedge clk or negedge rst) begin
        if(rst == 1'b0) 
            S <= WAIT;
        else
            S <= NS;
    end

	always @ (posedge clk or negedge rst)
	begin
		if(rst == 1'b0)
		begin
			cursor <= 6'd63;
			cursor2 <= 6'd63;
			data <= 64'd0;
         key <= 64'd0;
			char_count_1 <= 5'd0;
         char_count_2 <= 5'd0;
         dataLock <= 1'b0;
         inputComplete <= 1'b0;
		end
		else
		begin
            case(S)
                KYB2HEX: begin
                    if(dataLock == 1'd0)
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
                CRSR_INC: begin
                    if(dataLock == 1'd0) begin
                        char_count_1 <= char_count_1 + 5'd1;
								cursor <= cursor - 6'd4;
								end
                    else begin
                        char_count_2 <= char_count_2 + 5'd1;
								cursor2 <= cursor2 - 6'd4;
								end
                end
                DELETE: begin
                    if(dataLock == 1'd0) begin
								char_count_1 <= 5'd0;
								cursor <= 6'd63;
								end
                    else begin
                        char_count_2 <= 5'd0;
								cursor2 <= 6'd63;
								end
                end
                CRSR_DEC: begin
                    
                    if(dataLock == 1'd0) begin
								char_count_1 <= char_count_1 - 5'd1;
								cursor <= cursor + 6'd4;
								end
                    else begin
                        char_count_2 <= char_count_2 - 5'd1;
								cursor2 <= cursor2 + 6'd4;
								end
                end
                KEY_INPUT: begin
                    dataLock <= 1'b1;
                     // reset cursor for key input
                end
                DONE: inputComplete <= 1'b1;
            endcase
		end
	end
	
	always @(*)
	begin
		case (S)
			WAIT: begin
				if (keyBackspace)
					NS = CRSR_EDGE;
				else if (delete)
					NS = DELETE;
				else if (characters != 16'b0) // wait until press
					NS = KYB2HEX;
				else
					NS = WAIT;
			end
			CRSR_INC: NS = NEXT_CHAR;
			KYB_HELD: begin
				if (characters == 16'b0) // wait until release
					NS = CRSR_INC;
				else
					NS = KYB_HELD;
			end
			NEXT_CHAR: begin
				if (char_count_1 != 5'd16 && dataLock == 1'd0) // 16 chars typed and collecting data
					NS = WAIT;
				else if (char_count_1 == 5'd16 && dataLock == 1'd0)
					NS = FULL_BUFF;
                else if (char_count_2 != 5'd16 && dataLock == 1'd1) //collecting key
                    NS = WAIT;
                else if (char_count_2 == 5'd16 && dataLock == 1'd1)
                    NS = FINAL_BUFF;
			end
			FULL_BUFF: begin
				if (keyBackspace)
					NS = CRSR_DEC;
				else if (delete)
					NS = WAIT;
            else if (enter)
               NS = KEY_INPUT;
				else
					NS = FULL_BUFF;
			end
			FINAL_BUFF: begin
				if (keyBackspace)
					NS = CRSR_DEC;
				else if (delete)
					NS = WAIT;
            else if (enter)
               NS = DONE;
				else
					NS = FINAL_BUFF;
			end
			DELETE: NS = WAIT;
			CRSR_EDGE: begin
				if (char_count_1 == 5'd0 && dataLock == 1'd0)
					NS = BACKSPACE_HELD;
				else if (char_count_2 == 5'd0 && dataLock == 1'd1)
					NS = BACKSPACE_HELD;
            else
               NS = CRSR_DEC;
			end
			CRSR_DEC: NS = BACKSPACE_HELD;
			BACKSPACE_HELD: begin
				if (keyBackspace)
					NS = BACKSPACE_HELD;
				else
					NS = WAIT;
			end
			KYB2HEX: NS = KYB_HELD;
       KEY_INPUT: NS = WAIT;
            DONE: NS = DONE;
			default: NS = ERROR;
		endcase
	end
endmodule
	
		