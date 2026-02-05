// my_cpu.v -- top wrapper instantiating instruction ROM and CPU top


module my_cpu(
    input  wire clk,
    input  wire rst_n,
    output wire led,
    //debug interface
    output wire [31:0] debug_pc_out,
    output wire [31:0] reg3
);

    // Wires between instances
    wire [31:0] pc_out;
    wire [31:0] inst_q; // instruction ROM output

    // Wires between data RAM and CPU top
    wire [31:0] ext_raddr;
    wire        ext_re;
    wire [31:0] ext_rdata;
    wire [31:0] ext_waddr;
    wire        ext_we;
    wire [31:0] ext_wdata;
    wire [31:0] ext_rdata_r;


    // Instruction ROM instance (from inst_rom_inst.v)
    // Address uses word-aligned PC bits [11:2]; adjust slice if your ROM depth differs
    inst_rom inst_rom_inst (
        .address (pc_out[10:2]),
        .clock   (clk),
        .q       (inst_q)
    );

    // CPU top instance
    top u_top (
        .clk     (clk),
        .rst_n   (rst_n),
        .inst_in (inst_q),
        .pc_out  (pc_out),
        .led     (led),
        .reg3    (reg3),
        .debug_pc_out (debug_pc_out),
        .ext_raddr (ext_raddr),
        .ext_re    (ext_re),
        .ext_rdata (ext_rdata),
        .ext_waddr (ext_waddr),
        .ext_we    (ext_we),
        .ext_wdata (ext_wdata)
    );

    // Data RAM instance (from data_ram_inst.v)
    data_ram data_ram_inst (
        .clock     (clk),
        .data      (ext_wdata),
        .rdaddress (ext_raddr[10:2]), // Adjust slice for word-aligned addressing
        .rden      (ext_re),
        .wraddress (ext_waddr[10:2]), // Adjust slice for word-aligned addressing
        .wren      (ext_we),
        .q         (ext_rdata_r)
    );
    assign ext_rdata = (ext_raddr[10:2] == ext_waddr[10:2] && ext_we) ? ext_wdata : ext_rdata_r;

endmodule
