`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:17 11/30/2018 
// Design Name: 
// Module Name:    mul_rotx 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mul_rotx(a1,a2,a3,angle,tx, ty, tz, o1,o2,o3
    );

input signed [9:0] a1, a2, a3, tx, ty, tz;
input [5:0] angle;
output [9:0] o1, o2, o3;

wire signed [10:0] sinAng;
wire signed [10:0] cosAng;
reg [7:0] sinAngles [2:0];
reg [7:0] cosAngles [2:0];
//only taking the first 3 bits for simplicity atm
assign sinAng = sinAngles[angle[5:3]];
assign cosAng = cosAngles[angle[5:3]];

//increments of 45 degrees
//values are 2's complement
//first bit is sign, second bit is 2^1, subsequent are (1/2)^(n-2)
initial begin
	sinAngles[0] = 10'b0000000000;
	sinAngles[1] = 10'b0010110101;
	sinAngles[2] = 10'b0100000000;
	sinAngles[3] = 10'b0010110101;
	sinAngles[4] = 10'b0000000000;
	sinAngles[5] = 10'b1101001011;
	sinAngles[6] = 10'b1011111111;
	sinAngles[7] = 10'b1101001011;
	
end

initial begin
	cosAngles[0] = 10'b0100000000;
	cosAngles[1] = 10'b0010110101;
	cosAngles[2] = 10'b0000000000;
	cosAngles[3] = 10'b1101001011;
	cosAngles[4] = 10'b1100000000;
	cosAngles[5] = 10'b1101001011;
	cosAngles[6] = 10'b0000000000;
	cosAngles[7] = 10'b0010110101;
end

wire [19:0] o1tmp, o2tmp, o3tmp;
assign o1tmp = cosAng * a1 + sinAng * a3 + tx;
assign o2tmp = a2 + ty;
assign o3tmp = a1 * (-sinAng) + a3 * cosAng + tz;

assign o1 = o1tmp[19:10];
assign o2 = o2tmp[19:10];
assign o3 = o3tmp[19:10];

endmodule
