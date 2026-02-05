`timescale 1ns/1ps
module tb_my_cpu ();
reg clk;
reg rst_n;
wire led;
//debug interface
wire [31:0] debug_pc_out;
wire [31:0] reg3;

my_cpu u_my_cpu (
    .clk     (clk),
    .rst_n   (rst_n),
    .led     (led),
    .debug_pc_out (debug_pc_out),
    .reg3    (reg3)
);

initial begin
    clk = 0;
    rst_n = 0;
    #100;
    rst_n = 1;
end

always #10 clk = ~clk;   // 50MHz clock

initial begin
    if (debug_pc_out === 32'h00000044) begin
        $finish;
    end
end

endmodule