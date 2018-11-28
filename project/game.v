`timescale 1ns / 1ps

module game(clk, reset, write_data, wen);

input clk, reset;
reg [2:0] state;
output reg [65:0] write_data;
output reg wen;

wire [39:0] A0, A1, A2, A3, P0, C0;
wire [39:0] P1, C1;
wire [39:0] P2, C2;
mmulp mmulp1(A0, A1, A2, A3, P0, C0);
mmulp mmulp2(A0, A1, A2, A3, P1, C1);
mmulp mmulp3(A0, A1, A2, A3, P2, C2);

reg [95:0] faces [15:0];
reg [3:0] I;
wire [95:0] aface;
assign aface = faces[I];
initial begin
	faces[0] <= { {{10'b0},{10'b0},{10'b0}},{{10'd50},{10'd50},{10'b0}},{{10'd50},{10'b0},{10'b0}}, 6'b111111 };
	faces[1] <= { {{10'b0},{10'b0},{10'b0}},{{10'b0},{10'd50},{10'b0}},{{10'd50},{10'd50},{10'b0}}, 6'b111110 };
	faces[2] <= { {{10'b0},{10'b0},{10'b0}},{{10'b0},{10'd50},{10'd50}},{{10'b0},{10'd50},{10'b0}}, 6'b111101 };
	faces[3] <= { {{10'b0},{10'b0},{10'b0}},{{10'b0},{10'b0},{10'd50}},{{10'b0},{10'd50},{10'd50}}, 6'b111100 };
	faces[4] <= { {{10'b0},{10'd50},{10'b0}},{{10'd50},{10'd50},{10'd50}},{{10'd50},{10'd50},{10'b0}}, 6'b111011 };
	faces[5] <= { {{10'b0},{10'd50},{10'b0}},{{10'b0},{10'd50},{10'd50}},{{10'd50},{10'd50},{10'd50}}, 6'b110111 };
	faces[6] <= { {{10'd50},{10'b0},{10'b0}},{{10'd50},{10'd50},{10'b0}},{{10'd50},{10'd50},{10'd50}}, 6'b110011 };
	faces[7] <= { {{10'd50},{10'b0},{10'b0}},{{10'd50},{10'd50},{10'd50}},{{10'd50},{10'b0},{10'd50}}, 6'b101111 };
	faces[8] <= { {{10'b0},{10'b0},{10'b0}},{{10'd50},{10'b0},{10'b0}},{{10'd50},{10'b0},{10'd50}}, 6'b011111 };
	faces[9] <= { {{10'b0},{10'b0},{10'b0}},{{10'd50},{10'b0},{10'd50}},{{10'b0},{10'b0},{10'd50}}, 6'b101111 };
	faces[10] <= { {{10'b0},{10'b0},{10'd50}},{{10'd50},{10'b0},{10'd50}},{{10'd50},{10'd50},{10'd50}}, 6'b101010 };
	faces[11] <= { {{10'b0},{10'b0},{10'd50}},{{10'd50},{10'd50},{10'd50}},{{10'b0},{10'd50},{10'd50}}, 6'b010101 };
end

assign P0 = {aface[95:66], 10'b1};
assign P1 = {aface[65:36], 10'b1};
assign P2 = {aface[35:6], 10'b1};

assign A0 = {10'd1, 10'd0, 10'd0, 10'd270};
assign A1 = {10'd0, 10'd1, 10'd0, 10'd190};
assign A2 = {10'd0, 10'd0, 10'd0, 10'd0};
assign A3 = {10'd0, 10'd0, 10'd0, 10'd1};

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
				write_data <= {C0[39:30], C0[29:20], C1[39:30], C1[29:20], C2[39:30], C2[29:20], aface[5:0]};
				wen <= 1;
				I <= I + 1;
				if (I == 11)
					state <= WAIT;
			end

			WAIT : begin
			end

		endcase
	end
end

endmodule
