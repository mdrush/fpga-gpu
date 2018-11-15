`timescale 1ns / 1ps

module gpu(clk, reset, start, addr, dout, wen, done);

input clk, reset, start;
reg [1:0] state;
output reg done;
// reg [7:0] mem [0:640*480]; 
output wire [18:0] addr;
output reg [5:0] dout;
output reg wen;

reg [9:0] xmaxf, ymaxf, xminf, yminf, x, y;

wire [19:0] v0, v1, v2;

wire [2:0] edgeout;
edgef e0(.v0(v0), .v1(v1), .px(x), .py(y), .out(edgeout[0]));
edgef e1(.v0(v1), .v1(v2), .px(x), .py(y), .out(edgeout[1]));
edgef e2(.v0(v2), .v1(v0), .px(x), .py(y), .out(edgeout[2]));

assign v0 = {10'd230, 10'd200};
assign v1 = {10'd400, 10'd450};
assign v2 = {10'd170, 10'd400};

localparam INIT = 2'b00;
localparam DRAW = 2'b01;
localparam DONE = 2'b11;

assign addr = 640*y+x;

always@ (posedge clk)
begin
	if (reset) begin
		state <= INIT;
				xmaxf <= 10'bx;
				ymaxf <= 10'bx;
				xminf <= 10'bx;
				yminf <= 10'bx;

				x <= 10'bx;
				y <= 10'bx;
	end
	else begin
		case (state)
			INIT : begin : minmax
/*				reg [9:0] xmax, ymax, xmin, ymin;

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

				xmaxf <= xmax;
				ymaxf <= ymax;
				xminf <= xmin;
				yminf <= ymin;

				x <= xmin;
				y <= ymin;*/

			xmaxf <= 639;
				ymaxf <= 479;
				xminf <= 0;
				yminf <= 0;

				x <= 0;
				y <= 0;

				
				done <= 0;
				
				if (start)
					state <= DRAW;
			end

			DRAW : begin
				// FIXME: use tiling instead
				if (edgeout == 3'b000) begin
					wen <= 1'b1;
					dout <= 6'b111111;
				end
				else begin
					wen <= 1'b0;
					dout <= 6'b110011;
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
					wen <= 1'b0;
					state <= DONE;
					dout <= 6'b001100;
				end

			end

			DONE : begin
				done <= 1;
				
			end

		endcase
	end
end




endmodule
