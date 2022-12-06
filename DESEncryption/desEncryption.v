module desEncryption(
    input [63:0] data, key,
    input decrypt,
    output [63:0] out );


wire [47:0] sk1, sk2, sk3, sk4, sk5, sk6, sk7, sk8, sk9, sk10, sk11, sk12, sk13, sk14, sk15, sk16;

wire [31:0] f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16;

subKeys sk(key, sk1, sk2, sk3, sk4, sk5, sk6, sk7, sk8, sk9, sk10, sk11, sk12, sk13, sk14, sk15, sk16);

// IP - MSB on left, LSB on right
wire [63:0]IP = {data[6], data[14], data[22], data[30], data[38], data[46], data[54], data[62], data[4], data[12], data[20], data[28], data[36], data[44], data[52], data[60], data[2], data[10], data[18], data[26], data[34], data[42], data[50], data[58], data[0], data[8], data[16], data[24], data[32], data[40], data[48],             data[56], data[7], data[15], data[23], data[31], data[39], data[47], data[55], data[63], data[5], data[13], data[21], data[29], data[37], data[45], data[53], data[61], data[3], data[11], data[19], data[27], data[35], data[43], data[51], data[59], data[1], data[9], data[17], data[25], data[33], data[41], data[49], data[57]};
wire [31:0]L0 = {IP[63-:32]};
wire [31:0]R0 = {IP[31:0]};


wire [31:0] L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16;
wire [31:0] R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16;


// combinational, order of logic does not matter
// invert order keys are applied to decrypt
assign L1 = R0;
f fun1(R0, (decrypt ? sk16 : sk1), f1);
assign R1 = L0 ^ f1;

assign L2 = R1;
f fun2(R1, (decrypt ? sk15 : sk2), f2);
assign R2 = L1 ^ f2;

assign L3 = R2;
f fun3(R2, (decrypt ? sk14 : sk3), f3);
assign R3 = L2 ^ f3;

assign L4 = R3;
f fun4(R3, (decrypt ? sk13 : sk4), f4);
assign R4 = L3 ^ f4;

assign L5 = R4;
f fun5(R4, (decrypt ? sk12 : sk5), f5);
assign R5 = L4 ^ f5;

assign L6 = R5;
f fun6(R5, (decrypt ? sk11 : sk6), f6);
assign R6 = L5 ^ f6;

assign L7 = R6;
f fun7(R6, (decrypt ? sk10 : sk7), f7);
assign R7 = L6 ^ f7;

assign L8 = R7;
f fun8(R7, (decrypt ? sk9 : sk8), f8);
assign R8 = L7 ^ f8;

assign L9 = R8;
f fun9(R8, (decrypt ? sk8 : sk9), f9);
assign R9 = L8 ^ f9;

assign L10 = R9;
f fun10(R9, (decrypt ? sk7 : sk10), f10);
assign R10 = L9 ^ f10;

assign L11 = R10;
f fun11(R10, (decrypt ? sk6 : sk11), f11);
assign R11 = L10 ^ f11;

assign L12 = R11;
f fun12(R11, (decrypt ? sk5 : sk12), f12);
assign R12 = L11 ^ f12;

assign L13 = R12;
f fun13(R12, (decrypt ? sk4 : sk13), f13);
assign R13 = L12 ^ f13;

assign L14 = R13;
f fun14(R13, (decrypt ? sk3 : sk14), f14);
assign R14 = L13 ^ f14;

assign L15 = R14;
f fun15(R14, (decrypt ? sk2 : sk15), f15);
assign R15 = L14 ^ f15;

assign L16 = R15;
f fun16(R15, (decrypt ? sk1 : sk16), f16);
assign R16 = L15 ^ f16;



//final perm    (IP^-1)

wire [63:0] RL16  = {R16, L16};
assign out = {RL16[24], RL16[56], RL16[16], RL16[48], RL16[8], RL16[40], RL16[0], RL16[32], RL16[25], RL16[57], RL16[17], RL16[49], RL16[9], RL16[41], RL16[1], RL16[33], RL16[26], RL16[58], RL16[18], RL16[50], RL16[10], RL16[42], RL16[2], RL16[34], RL16[27], RL16[59], RL16[19], RL16[51], RL16[11], RL16[43], RL16[3], RL16[35], RL16[28], RL16[60], RL16[20], RL16[52], RL16[12], RL16[44], RL16[4], RL16[36], RL16[29], RL16[61], RL16[21], RL16[53], RL16[13], RL16[45], RL16[5], RL16[37], RL16[30], RL16[62], RL16[22], RL16[54], RL16[14], RL16[46], RL16[6], RL16[38], RL16[31], RL16[63], RL16[23], RL16[55], RL16[15], RL16[47], RL16[7], RL16[39]};



endmodule 