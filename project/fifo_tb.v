`timescale 1ns / 1ps

module fifo_tb();

reg reset_tb, clk_tb;

reg [3:0] write_data_tb;
wire [3:0] read_data_tb;
wire full, af, empty, ae;
reg wen, ren;

fifo #(4,3) UUT(.clk(clk_tb), 
.reset(reset_tb), 
.wen(wen), 
.ren(ren), 
.full(full), 
.empty(empty), 
.write_data(write_data_tb), 
.read_data(read_data_tb)
);

integer output_file;
initial 
   begin
	  //output_file = $fopen("output_results.txt", "w");
    $dumpfile("test.vcd");
    $dumpvars(0,fifo_tb);
   end


//CLK_GENERATOR
always
  begin  : CLK_GENERATOR
       #20 clk_tb = ~clk_tb;
end

// APPLYING STIMULUS
initial
begin

	wen=0;
	ren=0;
  clk_tb=0;
	reset_tb=1;
	#45;
	reset_tb=0;

	#100;

	// write
	write_data_tb = 4'b0000;
	repeat(9) begin
	#20;
	wen=1;
	#20;
	wen=0;
	write_data_tb = write_data_tb + 1'b1;
	end

	// read
	repeat(9) begin
	#20;
	ren=1;
	#20;
	ren=0;
	end

	// simultaneous read and write
	#20;
	write_data_tb = 4'b0000;
	wen=1;
	#20;
	wen=0;
	#20;
	write_data_tb = 4'b0001;
	wen=1;
	ren=1;
	#20;
	wen=0;
	ren=0;
	#20;

	
	#100;	
	

	$finish;
	
	
	end
endmodule
