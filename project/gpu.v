`timescale 1ns / 1ps

module gpu(clk, reset, start, addr, dout, wen, done, empty, ren, read_data);

input clk, reset, start, empty;
input [65:0] read_data;
reg [2:0] state;
output reg done, ren;
// reg [7:0] mem [0:640*480]; 
output wire [18:0] addr;
output reg [5:0] dout;
output reg wen;

reg [9:0] xmaxf, ymaxf, xminf, yminf, x, y;

reg [19:0] v0, v1, v2;
reg [5:0] color;

wire [2:0] edgeout;
edgef e0(.v0(v0), .v1(v1), .px(x), .py(y), .out(edgeout[0]));
edgef e1(.v0(v1), .v1(v2), .px(x), .py(y), .out(edgeout[1]));
edgef e2(.v0(v2), .v1(v0), .px(x), .py(y), .out(edgeout[2]));

reg [9:0] xmax, ymax, xmin, ymin;
always@* begin
				xmax = v0[19:10];
				if (xmax < v1[19:10])
					xmax = v1[19:10];
				if (xmax < v2[19:10])
					xmax = v2[19:10];

				xmin = v0[19:10];
				if (xmin > v1[19:10])
					xmin = v1[19:10];
				if (xmin > v2[19:10])
					xmin = v2[19:10];

				ymax = v0[9:0];
				if (ymax < v1[9:0])
					ymax = v1[9:0];
				if (ymax < v2[9:0])
					ymax = v2[9:0];

				ymin = v0[9:0];
				if (ymin > v1[9:0])
					ymin = v1[9:0];
				if (ymin > v2[9:0])
					ymin = v2[9:0];
end


localparam LOAD = 3'b100;
localparam LOAD2 = 3'b101;
localparam INIT = 3'b000;
localparam DRAW = 3'b001;
localparam DONE = 3'b011;

assign addr = 640*y+x;

always@ (posedge clk)
begin
	if (reset) begin
		state <= DONE;
				xmaxf <= 10'bx;
				ymaxf <= 10'bx;
				xminf <= 10'bx;
				yminf <= 10'bx;

				x <= 10'bx;
				y <= 10'bx;
	end
	else begin
		case (state)
			LOAD : begin
				done <= 0;
				ren <= 1;
				if (!empty)
					state <= LOAD2;
			end

			LOAD2 : begin
				{v0, v1, v2, color} = read_data[65:0];
				ren <= 0;
				if (!empty)
					state <= INIT;
				else
					state <= LOAD;
			end

			INIT : begin : minmax
				xmaxf <= xmax;
				ymaxf <= ymax;
				xminf <= xmin;
				yminf <= ymin;

				x <= xmin;
				y <= ymin;

/*			xmaxf <= 639;
				ymaxf <= 479;
				xminf <= 0;
				yminf <= 0;

				x <= 0;
				y <= 0;
*/

				done <= 0;
				
				state <= DRAW;
			end

			DRAW : begin
				// FIXME: use tiling instead
				ren <= 0;
				wen <= 0;
				if (edgeout == 3'b111) begin
					wen <= 1;
					dout <= color;
				end
				if (y < ymaxf) begin
					if (x < xmaxf) begin
						x <= x + 1;
					end
					else begin
						x <= xminf;
						y <= y + 1;
					end
				end
				else begin
					state <= DONE;
					if (!empty) begin
						state <= LOAD;
					end
				end

			end

			DONE : begin
				done <= 1;
					state <= LOAD;
			end

		endcase
	end
end




endmodule
