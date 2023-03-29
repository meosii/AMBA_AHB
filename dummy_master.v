`include "define.v"

module dummy_master(
input wire HCLK,
input wire HRESETn,
//from arbiter
input wire HGRANT,
//from slave
input wire HREADY,
input wire [31:0] HRDATA,
//to arbiter
output wire HBUSREQ,
output wire HLOCK,
//Address and control
output wire [31:0] HADDR,
output wire [1:0] HTRANS,
output wire [2:0] HBURST,
output wire [2:0] HSIZE,
output wire [31:0] HWDATA
);

assign HBUSREQ = 0;
assign HLOCK = 0;
assign HADDR = 0;
assign HTRANS = `IDLE;
assign HBURST = 0;
assign HSIZE = 0;
assign HWDATA = 0;

endmodule