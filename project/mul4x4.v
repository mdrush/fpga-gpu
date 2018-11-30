`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:04 11/27/2018 
// Design Name: 
// Module Name:    mul4x4 
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
module mul4x4(a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34,
	a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32,
	b33, b34, b41, b42, b43, b44, o11, o12, o13, o14, o21, o22, o23, o24,
	o31, o32, o33, o34, o41, o42, o43, o44
    );

input [7:0] a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34,
	a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32,
	b33, b34, b41, b42, b43, b44;

output [7:0] o11, o12, o13, o14, o21, o22, o23, o24,
	o31, o32, o33, o34, o41, o42, o43, o44;
	
	assign o11 = a11 * b11 + a21 * b12 + a31 * b13 + a41 * b14;
	assign o12 = a12 * b11 + a22 * b12 + a32 * b13 + a42 * b14;
	assign o13 = a13 * b11 + a23 * b12 + a33 * b13 + a43 * b14;
	assign o14 = a14 * b11 + a24 * b12 + a34 * b13 + a44 * b14;
	assign o21 = a11 * b21 + a21 * b22 + a31 * b23 + a41 * b24;
	assign o22 = a12 * b21 + a22 * b22 + a32 * b23 + a42 * b24;
	assign o23 = a13 * b21 + a23 * b22 + a33 * b23 + a43 * b24;
	assign o24 = a14 * b21 + a24 * b22 + a34 * b23 + a44 * b24;
	assign o31 = a11 * b31 + a21 * b32 + a31 * b33 + a41 * b34;
	assign o32 = a12 * b31 + a22 * b32 + a32 * b33 + a42 * b34;
	assign o33 = a13 * b31 + a23 * b32 + a33 * b33 + a43 * b34;
	assign o34 = a14 * b31 + a24 * b32 + a34 * b33 + a44 * b34;
	assign o41 = a11 * b41 + a21 * b42 + a31 * b43 + a41 * b44;
	assign o42 = a12 * b41 + a22 * b42 + a32 * b43 + a42 * b44;
	assign o43 = a13 * b41 + a23 * b42 + a33 * b43 + a43 * b44;
	assign o44 = a14 * b41 + a24 * b42 + a34 * b44 + a44 * b44;

endmodule
