module data (
    input wire clk,
    input wire [31:0] raddr,
    input wire re,
    output wire [31:0] rdata,
    input wire [31:0] waddr,
    input wire we,
    input wire [31:0] wdata
);

reg [31:0] ram [0:128]; // 512 bytes data memory
wire [6:0] idx_r = raddr[8:2]; // 32
wire [6:0] idx_w = waddr[8:2]; // 32

// Write operation: synchronous
always @(posedge clk) begin
    if (we) begin
        ram[idx_w] <= wdata;
    end
end

// Read operation: combinational
assign rdata = re ? ram[idx_r] : 32'h0;

endmodule