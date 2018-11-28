`timescale 1ns / 1ps

module mmulp(A0, A1, A2, A3, P, C);
	input [39:0] A0, A1, A2, A3;
	input [39:0] P;
	output [39:0] C;

	wire [9:0] x,y,z,w;
	assign {x,y,z,w} = P;

	assign C[39:30] = x*A0[39:30] + y*A0[29:20] + z*A0[19:10] + w*A0[9:0];
	assign C[29:20] = x*A1[39:30] + y*A1[29:20] + z*A1[19:10] + w*A1[9:0];
	assign C[19:10] = x*A2[39:30] + y*A2[29:20] + z*A2[19:10] + w*A2[9:0];
	assign C[9:0] = x*A3[39:30] + y*A3[29:20] + z*A3[19:10] + w*A3[9:0];

endmodule
