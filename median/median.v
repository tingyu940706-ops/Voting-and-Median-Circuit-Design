//===============================================================================//
//            PLEASE DO NOT modify basic I/O name or top module name!            // 
//===============================================================================//
 
module median (a0, a1, a2, a3, a4, out);

input    [5:0]   a0, a1, a2, a3, a4;

output   [5:0]   out;

//====================================================================
//======================= enter your code here =======================

wire [2:0] x0, x1, x2, x3, x4;
wire [2:0] ab_lo, ab_hi;
wire [2:0] cd_lo, cd_hi;
wire [2:0] L, H;
wire [2:0] mid_idx;

// ===========encoders===========

encoder_6to3 E0(.in(a0), .out(x0));
encoder_6to3 E1(.in(a1), .out(x1));
encoder_6to3 E2(.in(a2), .out(x2));
encoder_6to3 E3(.in(a3), .out(x3));
encoder_6to3 E4(.in(a4), .out(x4));

// ===========sort first two pairs===========

sort2 S0(.A(x0), .B(x1), .low(ab_lo), .high(ab_hi));
sort2 S1(.A(x2), .B(x3), .low(cd_lo), .high(cd_hi));

// ===========reduce four values into two bounds===========

max2 U0(.A(ab_lo), .B(cd_lo), .out(L));
min2 U1(.A(ab_hi), .B(cd_hi), .out(H));

// ===========median of three: L, H, x4===========

median3 M0(.A(L), .B(H), .C(x4), .M(mid_idx));

// ===========decode back to one-hot===========

decoder_3to6 D0(.in(mid_idx), .out(out));

//====================================================================

endmodule



//===============================

module encoder_6to3(in, out);

input  [5:0] in;
output [2:0] out;

assign out[2] = in[4] | in[5];
assign out[1] = in[2] | in[3];
assign out[0] = in[1] | in[3] | in[5];

endmodule

//===============================

module cmp3(A,B,sel);

input [2:0]A,B;
output sel;

wire x2,x1;

assign x2 = ~(A[2]^B[2]);
assign x1 = ~(A[1]^B[1]);

assign sel = (A[2] & ~B[2])|(x2 & A[1] & ~B[1])|(x2 & x1 & A[0] & ~B[0]);

endmodule

//===============================

module sort2(A, B, low, high);

input  [2:0] A, B;
output [2:0] low, high;

wire sels;

cmp3 u0(.A(A),.B(B),.sel(sels));

assign low = sels? B:A;
assign high = sels? A:B;

endmodule

//===============================

module max2(A, B, out);

input  [2:0] A, B;
output [2:0] out;

wire selM;

cmp3 u0(.A(A),.B(B),.sel(selM));

assign out = selM? A:B;

endmodule

//===============================

module min2(A, B, out);
input  [2:0] A, B;
output [2:0] out;

wire selm;

cmp3 u0(.A(A),.B(B),.sel(selm));

assign out = selm? B:A;

endmodule

//===============================

module median3(A, B, C, M);
input  [2:0] A, B, C;
output [2:0] M;

wire [2:0]ab_lo,ab_hi,T1;

sort2 u0(.A(A), .B(B), .low(ab_lo), .high(ab_hi));
max2  u1(.A(ab_lo), .B(C), .out(T1));
min2  u2(.A(ab_hi), .B(T1), .out(M));

endmodule

//===============================

module decoder_3to6(in, out);

input  [2:0] in;
output [5:0] out;

assign out[0] = ~in[2]&(~in[1])&(~in[0]);
assign out[1] = ~in[2]&(~in[1])&( in[0]);
assign out[2] = ~in[2]&( in[1])&(~in[0]);
assign out[3] = ~in[2]&( in[1])&( in[0]);
assign out[4] =  in[2]&(~in[1])&(~in[0]);
assign out[5] =  in[2]&(~in[1])&( in[0]);
// this decoder only maps 6 valid codes (0~5)

endmodule
