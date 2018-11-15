`timescale 1ns / 1ps

module gpu(clk, reset, addr, dout, wen, done);

input clk, reset;
reg [1:0] state;
output reg done;
// reg [7:0] mem [0:640*480]; 
output reg [18:0] addr;
output reg [7:0] dout;
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

always@ (posedge clk, posedge reset)
begin
	if (reset)
		state <= INIT;
	else begin
		case (state)
			INIT : begin : minmax
				reg [9:0] xmax, ymax, xmin, ymin;

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
				y <= ymin;

			/*xmaxf <= 639;
				ymaxf <= 479;
				xminf <= 0;
				yminf <= 0;

				x <= 0;
				y <= 0;*/

				state <= DRAW;
				done <= 0;
				


			end

			DRAW : begin
				// FIXME: use tiling instead
				if (edgeout == 3'b111) begin
					wen <= 1;
					dout <= 8'b11111111;
				end
				else
					wen <= 0;
		
				if (y < ymaxf) begin
					if (x < xmaxf) begin
						addr = 640*y+x;
						x <= x + 1;
					end
					else begin
						x <= xminf;
						y <= y + 1;
					end
				end
				else begin
					wen <= 0;
					state <= DONE;
				end

			end

			DONE : begin
				done <= 1;
				
			end

		endcase
	end
end




endmodule
