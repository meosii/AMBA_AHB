`include "define.v"
module default_slave (
    input wire HCLK,
    input wire HRESETn,
    input wire HSEL,
    input wire [31:0] HADDR,
    input wire HWRITE,
    input wire [1:0] HTRANS,
    input wire [2:0] HSIZE,
    input wire [2:0] HBURST,
    input wire [31:0] HWDATA,
    input wire [3:0] HMASTER,
    input wire HMASTLOCK,
    output reg HREADY,
    output reg [1:0] HRESP,
    output reg [31:0] HRDATA,
    output reg [3:0] HSPLIT
);
    
always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        HREADY <= 0;
        HRESP <= 0;
        HRDATA <= 0;
        HSPLIT <= 0;
    end else if (HSEL) begin
        if (HTRANS == `IDLE || HTRANS == `BUSY) begin
            HREADY <= 1;
            HRESP <= `OKAY;
            HRDATA <= 0;
            HSPLIT <= 0;
        end else begin //HTRANS is NONSEQ or SEQ
            HREADY <= 1;
            HRESP <= `ERROR;
            HRDATA <= 0;
            HSPLIT <= 0;
        end
    end else begin
        HREADY <= 0;
        HRESP <= 0;
        HRDATA <= 0;
        HSPLIT <= 0;
    end
end

endmodule