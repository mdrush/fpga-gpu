`timescale 1ns / 1ps

module transform(x, y, z, w, sx, sy, posy, posx);
	input signed [9:0] x, y, z, w;
	input signed [9:0] posy, posx;

	wire signed [9:0] cx,cy,cz,cw;

	output wire signed [9:0] sx, sy;

	//wire signed [9:0] x,y,z,w;

	wire signed [9:0] a11, a12, a13, a14;
	wire signed [9:0] a21, a22, a23, a24;
	wire signed [9:0] a31, a32, a33, a34;
	wire signed [9:0] a41, a42, a43, a44;
	wire signed [9:0] camz;
	assign camz = 10'd4;

	// combined transform matrix
	assign a11 = 10'd1; assign a12 = 10'd0; assign a13 = 10'd0; assign a14 = posx;
	assign a21 = 10'd0; assign a22 = 10'd1; assign a23 = 10'd0; assign a24 = posy;
	assign a31 = 10'd0; assign a32 = 10'd0; assign a33 = -10'd1; assign a34 = camz;
	assign a41 = 10'd0; assign a42 = 10'd0; assign a43 = -10'd1; assign a44 = camz;

	assign cx = x*a11 + y*a12 + z*a13 + w*a14;
	assign cy = x*a21 + y*a22 + z*a23 + w*a24;
	assign cz = x*a31 + y*a32 + z*a33 + w*a34;
	assign cw = x*a41 + y*a42 + z*a43 + w*a44;
	
	assign sx = (((10'd320)*cx) / cw) + 0;
	assign sy = (((10'd240)*cy) / cw) + 0;

endmodule

