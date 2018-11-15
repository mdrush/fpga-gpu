`timescale 1ns / 1ps

module edgef(v0, v1, px, py, out);
	input [19:0] v0, v1;
	input [9:0] px, py;
	output out;
	wire signed [11:0] dX, dY, t1, t2;
	wire signed [23:0] o1, o2;

	assign dX = v1[19:10] - v0[19:10];
	assign dY = v1[9:0] - v0[9:0];

	assign t1 = (px-v0[19:10]);
	assign t2 = (py-v0[9:0]);

	assign o1 = t1*dY;
	assign o2 = t2*dX;
	assign out = (o1 >= o2);

endmodule

