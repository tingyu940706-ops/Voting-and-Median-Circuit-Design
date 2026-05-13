//===============================================================================//
//            PLEASE DO NOT modify basic I/O name or top module name!            // 
//===============================================================================//

//M1:Bit-wise counting

module voting (a0, a1, a2, a3, a4, out, count);

input    [4:0]   a0, a1, a2, a3, a4;

output   [4:0]   out;
output   [2:0]   count;

//====================================================================
//======================= enter your code here =======================

wire [4:0] code0,code1,code2,code3,code4,w1,w2,w3,winner;
wire s1,s2,s3,s4,s5,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,sel1,sel2,sel3,sel4;
wire [2:0] count0,count1,count2,count3,count4,count_w1,count_w2,count_w3,count_winner;

assign code0 = 5'b00001;
assign code1 = 5'b00010;
assign code2 = 5'b00100;
assign code3 = 5'b01000;
assign code4 = 5'b10000;

//====================get counts to know which get the most votes=====================

FA u0(.A(a0[0]),.B(a1[0]),.Cin(a2[0]),.S(s1),.Cout(c1));
FA u00(.A(a3[0]),.B(a4[0]),.Cin(s1),.S(count0[0]),.Cout(c2));
HA h0(.A(c1),.B(c2),.S(count0[1]),.Cout(count0[2]));

FA u1(.A(a0[1]),.B(a1[1]),.Cin(a2[1]),.S(s2),.Cout(c3));
FA u11(.A(a3[1]),.B(a4[1]),.Cin(s2),.S(count1[0]),.Cout(c4));
HA h1(.A(c3),.B(c4),.S(count1[1]),.Cout(count1[2]));

FA u2(.A(a0[2]),.B(a1[2]),.Cin(a2[2]),.S(s3),.Cout(c5));
FA u22(.A(a3[2]),.B(a4[2]),.Cin(s3),.S(count2[0]),.Cout(c6));
HA h2(.A(c5),.B(c6),.S(count2[1]),.Cout(count2[2]));

FA u3(.A(a0[3]),.B(a1[3]),.Cin(a2[3]),.S(s4),.Cout(c7));
FA u33(.A(a3[3]),.B(a4[3]),.Cin(s4),.S(count3[0]),.Cout(c8));
HA h3(.A(c7),.B(c8),.S(count3[1]),.Cout(count3[2]));

FA u4(.A(a0[4]),.B(a1[4]),.Cin(a2[4]),.S(s5),.Cout(c9));
FA u44(.A(a3[4]),.B(a4[4]),.Cin(s5),.S(count4[0]),.Cout(c10));
HA h4(.A(c9),.B(c10),.S(count4[1]),.Cout(count4[2]));

//==========layer1:node1,node2=================

cmp3 n1(.A(count0),.B(count1),.sel(sel1));
winner_select W1(.codeA(code0),.codeB(code1),.countA(count0),.countB(count1),.sel(sel1),.code(w1),.count(count_w1));

cmp3 n2(.A(count2),.B(count3),.sel(sel2));
winner_select W2(.codeA(code2),.codeB(code3),.countA(count2),.countB(count3),.sel(sel2),.code(w2),.count(count_w2));

//==========layer2:node3=================

cmp3 n3(.A(count_w1),.B(count_w2),.sel(sel3));
winner_select W3(.codeA(w1),.codeB(w2),.countA(count_w1),.countB(count_w2),.sel(sel3),.code(w3),.count(count_w3));

//==========layer3:node4=================

cmp3 n4(.A(count_w3),.B(count4),.sel(sel4));
winner_select W4(.codeA(w3),.codeB(code4),.countA(count_w3),.countB(count4),.sel(sel4),.code(winner),.count(count_winner));

//==========connect final node===========

assign out   = winner;
assign count = count_winner;

//====================================================================

endmodule

//=========================Full_Adder===========================================



module FA(A,B,Cin,S,Cout);

input A,B,Cin;
output S,Cout;

wire s1,c1,c2;

HA u0(.A(A),.B(B),.S(s1),.Cout(c1));
HA u1(.A(s1),.B(Cin),.S(S),.Cout(c2));

assign Cout=c2|c1;

endmodule

//=========================Half_Adder===========================================

module HA(A,B,S,Cout);
input A,B;
output S,Cout;

assign S    = A^B;
assign Cout = A&B;

endmodule



//==============comparator===============

module cmp3(A,B,sel);

input [2:0]A,B;
output sel;

wire x2,x1;

assign x2 = ~(A[2]^B[2]);
assign x1 = ~(A[1]^B[1]);

assign sel = (A[2] & ~B[2])|(x2 & A[1] & ~B[1])|(x2 & x1 & A[0] & ~B[0]);

endmodule

//============winner_select=============

module winner_select(codeA,codeB,countA,countB,sel,code,count);

input [4:0] codeA,codeB;
input [2:0]countA,countB;
input sel;

output [4:0] code;
output [2:0] count; 

assign code  = sel ? codeA  : codeB;
assign count = sel ? countA : countB;

endmodule