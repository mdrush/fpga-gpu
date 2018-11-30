`timescale 1ns / 1ps

module game(clk, reset, write_data, wen, btns, empty, posy, posx);

input clk, reset, empty;
input [4:0] btns;
reg [2:0] state;
output reg [65:0] write_data;
output reg wen;
wire btnU, btnD, btnL, btnR, btnC;
assign {btnU, btnD, btnL, btnR, btnC} = btns;
input signed [9:0] posy, posx;

wire signed [9:0] v0x, v0y, v0z, s0x, s0y;
wire signed [9:0] v1x, v1y, v1z, s1x, s1y;
wire signed [9:0] v2x, v2y, v2z, s2x, s2y;
wire [9:0] vw = 10'd1;
transform transform1(v0x, v0y, v0z, vw, s0x, s0y, posy, posx);
transform transform2(v1x, v1y, v1z, vw, s1x, s1y, posy, posx);
transform transform3(v2x, v2y, v2z, vw, s2x, s2y, posy, posx);

reg [95:0] faces [15:0];
reg [3:0] I;
wire [95:0] aface;
assign aface = faces[I];
initial begin
	faces[0] <= { {{10'b0},{10'b0},{10'b0}},{{10'd01},{10'd01},{10'b0}},{{10'd01},{10'b0},{10'b0}}, 6'b111111 };
	faces[1] <= { {{10'b0},{10'b0},{10'b0}},{{10'b0},{10'd01},{10'b0}},{{10'd01},{10'd01},{10'b0}}, 6'b111110 };
	faces[2] <= { {{10'b0},{10'b0},{10'b0}},{{10'b0},{10'd01},{10'd01}},{{10'b0},{10'd01},{10'b0}}, 6'b111001 };
	faces[3] <= { {{10'b0},{10'b0},{10'b0}},{{10'b0},{10'b0},{10'd01}},{{10'b0},{10'd01},{10'd01}}, 6'b111100 };
	faces[4] <= { {{10'b0},{10'd01},{10'b0}},{{10'd01},{10'd01},{10'd01}},{{10'd01},{10'd01},{10'b0}}, 6'b111011 };
	faces[5] <= { {{10'b0},{10'd01},{10'b0}},{{10'b0},{10'd01},{10'd01}},{{10'd01},{10'd01},{10'd01}}, 6'b100111 };
	faces[6] <= { {{10'd01},{10'b0},{10'b0}},{{10'd01},{10'd01},{10'b0}},{{10'd01},{10'd01},{10'd01}}, 6'b110011 };
	faces[7] <= { {{10'd01},{10'b0},{10'b0}},{{10'd01},{10'd01},{10'd01}},{{10'd01},{10'b0},{10'd01}}, 6'b101110 };
	faces[8] <= { {{10'b0},{10'b0},{10'b0}},{{10'd01},{10'b0},{10'b0}},{{10'd01},{10'b0},{10'd01}}, 6'b000010 };
	faces[9] <= { {{10'b0},{10'b0},{10'b0}},{{10'd01},{10'b0},{10'd01}},{{10'b0},{10'b0},{10'd01}}, 6'b000011 };
	faces[10] <= { {{10'b0},{10'b0},{10'd01}},{{10'd01},{10'b0},{10'd01}},{{10'd01},{10'd01},{10'd01}}, 6'b101010 };
	faces[11] <= { {{10'b0},{10'b0},{10'd01}},{{10'd01},{10'd01},{10'd01}},{{10'b0},{10'd01},{10'd01}}, 6'b010101 };
end

assign v0x = aface[95:86]; assign v0y = aface[85:76]; assign v0z = aface[75:66];
assign v1x = aface[65:56]; assign v1y = aface[55:46]; assign v1z = aface[45:36];
assign v2x = aface[35:26]; assign v2y = aface[25:16]; assign v2z = aface[15:6];


localparam INIT = 3'b000;
localparam TX = 3'b001;
localparam WAIT = 3'b011;

always@ (posedge clk)
begin
	if (reset) begin
		state <= INIT;
		I <= 4'b0;
		write_data <= 66'bx;
		
	end
	else begin
		wen <= 0;
		case (state)

			INIT : begin
				I <= 4'b0;
				state <= TX;
			end

			TX : begin
				write_data <= {s0x, s0y, s1x, s1y, s2x, s2y, aface[5:0]};
				wen <= 1;
				I <= I + 1;
				if (I == 11)
					state <= WAIT;
			end

			WAIT : begin
				if (empty && (btns == 5'b00000))
					state <= INIT;
			end

		endcase
	end
end

endmodule
