`timescale 1ns / 1ps

module mmul_tb();

reg [39:0] A0, A1, A2, A3;
reg [39:0] P;
wire [39:0] C;

mmulp mmulp_uut(A0, A1, A2, A3, P, C);

initial begin
	$dumpfile("test_mmulp.vcd");
	$dumpvars(0,mmulp_uut);
end

initial begin
	assign A0 = {10'd5, 10'd6, 10'd5, 10'd3};
	assign A1 = {10'd18, 10'd4, 10'd10, 10'd0};
	assign A2 = {10'd6, 10'd18, 10'd7, 10'd12};
	assign A3 = {10'd1, 10'd14, 10'd4, 10'd2};
	assign P = {10'd1, 10'd1, 10'd1, 10'd1};

	
	#20;
	$display("%d\t%d\t%d\t%d\n", C[39:30], C[29:20], C[19:10], C[9:0]);

	$finish;

end



endmodule
