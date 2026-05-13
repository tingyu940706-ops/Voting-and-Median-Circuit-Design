//===============================================================================//
//            PLEASE DO NOT modify basic I/O name or top module name!            //
//===============================================================================//

// M2: Candidate Equality Matching

module voting (a0, a1, a2, a3, a4, out, count);

input  [4:0] a0, a1, a2, a3, a4;
output [4:0] out;
output [2:0] count;

//====================================================================
//======================= enter your code here =======================

// candidate codes
wire [4:0] code0, code1, code2, code3, code4;

// equality results for each candidate against all inputs
wire eq00, eq01, eq02, eq03, eq04;
wire eq10, eq11, eq12, eq13, eq14;
wire eq20, eq21, eq22, eq23, eq24;
wire eq30, eq31, eq32, eq33, eq34;
wire eq40, eq41, eq42, eq43, eq44;

// count of each candidate
wire [2:0] count0, count1, count2, count3, count4;

// comparator tree signals
wire sel1, sel2, sel3, sel4;
wire [4:0] w1, w2, w3, winner;
wire [2:0] count_w1, count_w2, count_w3, count_winner;

//---------------------------------------------------------
// define five legal one-hot candidates
//---------------------------------------------------------
assign code0 = 5'b00001;
assign code1 = 5'b00010;
assign code2 = 5'b00100;
assign code3 = 5'b01000;
assign code4 = 5'b10000;

//---------------------------------------------------------
// compare candidate 00001 with all inputs
//---------------------------------------------------------
eq5 E00(.A(code0), .B(a0), .eq(eq00));
eq5 E01(.A(code0), .B(a1), .eq(eq01));
eq5 E02(.A(code0), .B(a2), .eq(eq02));
eq5 E03(.A(code0), .B(a3), .eq(eq03));
eq5 E04(.A(code0), .B(a4), .eq(eq04));

//---------------------------------------------------------
// compare candidate 00010 with all inputs
//---------------------------------------------------------
eq5 E10(.A(code1), .B(a0), .eq(eq10));
eq5 E11(.A(code1), .B(a1), .eq(eq11));
eq5 E12(.A(code1), .B(a2), .eq(eq12));
eq5 E13(.A(code1), .B(a3), .eq(eq13));
eq5 E14(.A(code1), .B(a4), .eq(eq14));

//---------------------------------------------------------
// compare candidate 00100 with all inputs
//---------------------------------------------------------
eq5 E20(.A(code2), .B(a0), .eq(eq20));
eq5 E21(.A(code2), .B(a1), .eq(eq21));
eq5 E22(.A(code2), .B(a2), .eq(eq22));
eq5 E23(.A(code2), .B(a3), .eq(eq23));
eq5 E24(.A(code2), .B(a4), .eq(eq24));

//---------------------------------------------------------
// compare candidate 01000 with all inputs
//---------------------------------------------------------
eq5 E30(.A(code3), .B(a0), .eq(eq30));
eq5 E31(.A(code3), .B(a1), .eq(eq31));
eq5 E32(.A(code3), .B(a2), .eq(eq32));
eq5 E33(.A(code3), .B(a3), .eq(eq33));
eq5 E34(.A(code3), .B(a4), .eq(eq34));

//---------------------------------------------------------
// compare candidate 10000 with all inputs
//---------------------------------------------------------
eq5 E40(.A(code4), .B(a0), .eq(eq40));
eq5 E41(.A(code4), .B(a1), .eq(eq41));
eq5 E42(.A(code4), .B(a2), .eq(eq42));
eq5 E43(.A(code4), .B(a3), .eq(eq43));
eq5 E44(.A(code4), .B(a4), .eq(eq44));

//---------------------------------------------------------
// count how many times each candidate appears
//---------------------------------------------------------
count5bits C0(.x({eq00, eq01, eq02, eq03, eq04}), .count(count0));
count5bits C1(.x({eq10, eq11, eq12, eq13, eq14}), .count(count1));
count5bits C2(.x({eq20, eq21, eq22, eq23, eq24}), .count(count2));
count5bits C3(.x({eq30, eq31, eq32, eq33, eq34}), .count(count3));
count5bits C4(.x({eq40, eq41, eq42, eq43, eq44}), .count(count4));

//---------------------------------------------------------
// comparator tree
// IMPORTANT: this is exactly the same tie rule as M1
// A > B choose A, otherwise choose B
//---------------------------------------------------------

// level 1
cmp3 n1(.A(count0), .B(count1), .sel(sel1));
winner_select W1(.codeA(code0), .codeB(code1), .countA(count0), .countB(count1), .sel(sel1), .code(w1), .count(count_w1));

cmp3 n2(.A(count2), .B(count3), .sel(sel2));
winner_select W2(.codeA(code2), .codeB(code3), .countA(count2), .countB(count3), .sel(sel2), .code(w2), .count(count_w2));

// level 2
cmp3 n3(.A(count_w1), .B(count_w2), .sel(sel3));
winner_select W3(.codeA(w1), .codeB(w2), .countA(count_w1), .countB(count_w2), .sel(sel3), .code(w3), .count(count_w3));

// final level
cmp3 n4(.A(count_w3), .B(count4), .sel(sel4));
winner_select W4(.codeA(w3), .codeB(code4), .countA(count_w3), .countB(count4), .sel(sel4), .code(winner), .count(count_winner));

// final outputs
assign out   = winner;
assign count = count_winner;

//====================================================================

endmodule


//========================= equality comparator =========================

module eq5(A, B, eq);

input  [4:0] A, B;
output eq;

wire x0, x1, x2, x3, x4;

assign x0 = ~(A[0] ^ B[0]);
assign x1 = ~(A[1] ^ B[1]);
assign x2 = ~(A[2] ^ B[2]);
assign x3 = ~(A[3] ^ B[3]);
assign x4 = ~(A[4] ^ B[4]);

assign eq = x0 & x1 & x2 & x3 & x4;

endmodule


//========================= count 5 one-bit inputs =========================

module count5bits(x, count);

input  [4:0] x;
output [2:0] count;

wire s1, c1, c2;

FA u0(.A(x[0]), .B(x[1]), .Cin(x[2]), .S(s1),       .Cout(c1));
FA u1(.A(x[3]), .B(x[4]), .Cin(s1),   .S(count[0]), .Cout(c2));
HA u2(.A(c1),   .B(c2),                .S(count[1]), .Cout(count[2]));

endmodule


//========================= Full Adder =========================

module FA(A, B, Cin, S, Cout);

input A, B, Cin;
output S, Cout;

wire s1, c1, c2;

HA u0(.A(A),  .B(B),   .S(s1), .Cout(c1));
HA u1(.A(s1), .B(Cin), .S(S),  .Cout(c2));

assign Cout = c1 | c2;

endmodule


//========================= Half Adder =========================

module HA(A, B, S, Cout);

input A, B;
output S, Cout;

assign S    = A ^ B;
assign Cout = A & B;

endmodule


//========================= comparator =========================

module cmp3(A, B, sel);

input [2:0] A, B;
output sel;

wire x2, x1;

assign x2 = ~(A[2] ^ B[2]);
assign x1 = ~(A[1] ^ B[1]);

assign sel = (A[2] & ~B[2]) | (x2 & A[1] & ~B[1]) | (x2 & x1 & A[0] & ~B[0]);

endmodule


//========================= winner select =========================

module winner_select(codeA, codeB, countA, countB, sel, code, count);

input [4:0] codeA, codeB;
input [2:0] countA, countB;
input sel;

output [4:0] code;
output [2:0] count;

assign code  = sel ? codeA  : codeB;
assign count = sel ? countA : countB;

endmodule