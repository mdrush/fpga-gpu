`timescale 1ns / 1ps
// Verilog implementation of Gandhi Puvvada's Synchronous FIFO design

module fifo(clk, reset, wen, ren, full, almost_full, empty, almost_empty, write_data, read_data);

parameter DATA_WIDTH = 4;
parameter ADDR_WIDTH = 3; // must be >= 3
parameter FIFO_DEPTH = 1 << ADDR_WIDTH;

input clk, reset, wen, ren;
input [DATA_WIDTH-1:0] write_data;
output reg [DATA_WIDTH-1:0] read_data;

// dual port RAM
reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

reg [ADDR_WIDTH-1:0] write_address, read_address;
wire [ADDR_WIDTH-1:0] diff = write_address - read_address;
wire wenq = wen & ~full;
wire renq = ren & ~empty;
wire raw_almost_full = &diff[ADDR_WIDTH-1:1]; 
wire raw_almost_empty = ~|diff[ADDR_WIDTH-1:2] & diff[1]; 
wire eq = ~|diff;
output empty;
assign empty = eq & almost_empty;
output full;
assign full = eq & almost_full;

output reg almost_full;
output reg almost_empty;

always @(posedge clk)
begin

	if (reset) begin
		almost_empty <= 1;
		almost_full <= 0;
		write_address <= 0;
		read_address <= 0;
	end
	else begin

		if (wenq) begin
			mem[write_address] <= write_data;
			write_address <= write_address + 1'b1;
		end
		if (renq) begin
			read_data <= mem[read_address];
			read_address <= read_address + 1'b1;
		end

		if (almost_empty) begin
			// Most recently seen the FIFO running almost empty
			if (raw_almost_full) begin
				almost_full <= 1;
				almost_empty <= 0;
			end
		end
		else begin
			// Most recently seen the FIFO running almost full
			if (raw_almost_empty) begin
				almost_full <= 0;
				almost_empty <= 1;
			end
		end

	end
	
end


endmodule


