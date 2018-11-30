`timescale 1ns / 1ps

module mmul_tb();

reg signed [9:0] px, py, pz, pw;

transform uut(.x(px), .y(py), .z(pz), .w(pw));

initial begin
	$dumpfile("test_transform.vcd");
	$dumpvars(0,uut);
end

initial begin
	assign px = 10'd1; assign py = 10'd1; assign pz = 10'd0; assign pw = 10'd1;

	$display("%d\t%d\t%d\t%d", uut.x, uut.y, uut.z, uut.w);
	$display("%d\t%d\t%d\t%d", uut.cx, uut.cy, uut.cz, uut.cw);
	$display("%d\t%d", uut.sx, uut.sy);

	$finish;

end



endmodule
