`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:07 11/28/2018 
// Design Name: 
// Module Name:    mul4x1_4x4 
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
module mul4x1_4x4(a1,a2,a3,a4,b11,b12,b13,b14,b21,b22,b23,b24,
b31,b32,b33,b34,b41,b42,b43,b44,o1,o2,o3,o4
    );
	 
input [7:0] a1,a2,a3,a4,b11,b12,b13,b14,b21,b22,b23,b24,
b31,b32,b33,b34,b41,b42,b43,b44;
output [7:0] o1,o2,o3,o4;

assign o1 = a1 * b11 + a2 * b12 + a3 * b13 + a4 * b14;
assign o2 = a1 * b21 + a2 * b22 + a3 * b23 + a4 * b24;
assign o3 = a1 * b31 + a2 * b32 + a3 * b33 + a4 * b34;
assign o4 = a1 * b41 + a2 * b42 + a3 * b43 + a4 * b44;


endmodule
