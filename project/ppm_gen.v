`timescale 1ns / 1ps

module ppm_gen();

reg reset_tb, clk_tb;

reg [5:0] mem [0:640*480]; 

reg [9:0] I, J;
reg [9:0] i, j;
localparam J_max = 10'd639;
localparam I_max = 10'd479;

reg [2:0] red, green;
reg [1:0] blue;

integer output_file;

input [18:0] addr_tb;
input wen_tb, done;
input [7:0] dout_tb;

reg [23:0] faces [0:63];

initial begin
	$readmemh("faces.data", faces);
end


gpu gpu_uut(.clk(clk_tb), .reset(reset_tb), .addr(addr_tb), .wen(wen_tb), .dout(dout_tb), .done(done_tb));

task output_image_file;
  begin
	$fdisplay(output_file, "P3\n640 480\n7"); // header
	for (I=0; I<=I_max; I=I+1) begin
		for (J=0; J<=J_max; J=J+1) begin
				red = mem[640*I+J][7:5];
				green = mem[640*I+J][4:2];
				blue = mem[640*I+J][1:0];
				$fwrite(output_file, "%d %d %d ", red, green, 2*blue);
		end	
		$fwrite(output_file, "\n");
	end
  end
endtask 

initial 
   begin
	  output_file = $fopen("output_results.ppm", "w");
    $dumpfile("test.vcd");
    $dumpvars(0,gpu_uut);
   end


//CLK_GENERATOR
always
  begin  : CLK_GENERATOR
       #20 clk_tb = ~clk_tb;
end

initial begin
	for (i=0; i<=I_max; i=i+1) begin
		for (j=0; j<=J_max; j=j+1) begin
			mem[640*i+j] = 0;
			//mem[640*i+j][7:5] = i[8:6];
			//mem[640*i+j][4:2] = j[8:6];
			//mem[640*i+j][1:0] = j[5:4];
		end
	end
end


always@ (posedge clk_tb)
begin
	if (wen_tb)
		mem[addr_tb] = dout_tb;
end

// APPLYING STIMULUS
initial
begin

  clk_tb=0;
	reset_tb=1;
	#45;
	reset_tb=0;

	#100;
	@ (posedge done_tb);
	#10;
	
	output_image_file;

	$finish;
	
	
	end
endmodule
