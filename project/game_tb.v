`timescale 1ns / 1ps

module ppm_gen();

reg reset_tb, clk_tb;

reg [5:0] mem [0:640*480]; 

reg [9:0] I, J;
reg [9:0] i, j;
localparam J_max = 10'd639;
localparam I_max = 10'd479;

reg [1:0] red, green;
reg [1:0] blue;

integer output_file;

input [18:0] addr_tb;
input wen_tb, done;
input [5:0] dout_tb;
reg start_tb;

wire [65:0] read_data_tb;
wire [65:0] write_data_tb;
wire full, af, empty, ae;
wire wen_fifo; 
wire ren_fifo;

fifo #(66,4) fifo_tb(.clk(clk_tb), 
.reset(reset_tb), 
.wen(wen_fifo), 
.ren(ren_fifo), 
.full(full), 
.empty(empty), 
.write_data(write_data_tb), 
.read_data(read_data_tb)
);

gpu gpu_tb(.clk(clk_tb), 
.reset(reset_tb), 
.start(start_tb), 
.addr(addr_tb), 
.wen(wen_tb), 
.dout(dout_tb), 
.done(done_tb),
.empty(empty),
.ren(ren_fifo),
.read_data(read_data_tb)
);

game game_uut(.clk(clk_tb), .reset(reset_tb), .write_data(write_data_tb), .wen(wen_fifo));

task output_image_file;
  begin
	$fdisplay(output_file, "P3\n640 480\n3"); // header
	for (I=0; I<=I_max; I=I+1) begin
		for (J=0; J<=J_max; J=J+1) begin
				red = mem[640*I+J][5:4];
				green = mem[640*I+J][3:2];
				blue = mem[640*I+J][1:0];
				$fwrite(output_file, "%d %d %d ", red, green, blue);
		end	
		$fwrite(output_file, "\n");
	end
  end
endtask 

initial 
   begin
	  output_file = $fopen("output_results.ppm", "w");
    $dumpfile("test.vcd");
    $dumpvars(0,ppm_gen);
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

localparam INIT = 3'b000;
localparam TX = 3'b001;
localparam WAIT = 3'b011;
reg [4*8:1] state_string;
always @(game_uut.I) begin
  case (game_uut.state)
	INIT   :		state_string = "INIT";
	TX  :		state_string = "TX  ";
	WAIT  :		state_string = "WAIT";
	default  : 	state_string = "unkn";
  endcase

	$write("I: %d\tState: %s\n", game_uut.I, state_string);
	$write("(%d,%d,%d,%d)\t(%d,%d,%d,%d)\t(%d,%d,%d,%d)\n", 
		game_uut.transform1.x, game_uut.transform1.y, game_uut.transform1.z, game_uut.transform1.w,
		game_uut.transform2.x, game_uut.transform2.y, game_uut.transform2.z, game_uut.transform2.w,
		game_uut.transform3.x, game_uut.transform3.y, game_uut.transform3.z, game_uut.transform3.w);
	$write("(%d,%d,%d,%d)\t(%d,%d,%d,%d)\t(%d,%d,%d,%d)\n", 
		game_uut.transform1.cx, game_uut.transform1.cy, game_uut.transform1.cz, game_uut.transform1.cw,
		game_uut.transform2.cx, game_uut.transform2.cy, game_uut.transform2.cz, game_uut.transform2.cw,
		game_uut.transform3.cx, game_uut.transform3.cy, game_uut.transform3.cz, game_uut.transform3.cw);
	$write("(%d,%d)\t(%d,%d)\t(%d,%d)\n", 
		game_uut.transform1.sx, game_uut.transform1.sy,
		game_uut.transform2.sx, game_uut.transform2.sy,
		game_uut.transform3.sx, game_uut.transform3.sy);
end

// APPLYING STIMULUS
initial
begin

	start_tb=0;
  clk_tb=0;
	reset_tb=1;
	#45;
	reset_tb=0;
	
	#100;
/*	write_data_tb = {{10'd230, 10'd200}, {10'd400, 10'd450}, {10'd170, 10'd400}, 6'b111111};
	wen_fifo = 1;
	#40;
	wen_fifo = 0;
	#40;
	write_data_tb = {{10'd130, 10'd100}, {10'd300, 10'd350}, {10'd070, 10'd300}, 6'b110000};
	wen_fifo = 1;
	#40;
	wen_fifo = 0;
	#40;
	write_data_tb = {{10'd330, 10'd200}, {10'd500, 10'd450}, {10'd270, 10'd400}, 6'b000011};
	wen_fifo = 1;
	#40;
	wen_fifo = 0;
	#40;*/
	
	start_tb=1;
	#60;
	start_tb=0;


	#100;
	@ (posedge done_tb);
	#10;
	
	output_image_file;

	$finish;
	
	
	end
endmodule
