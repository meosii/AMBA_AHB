`include "define.v"

module mux_s2m (
    input wire HMASTER,
    input wire HREADY,
    input wire [31:0] HRDATA,
    input wire [1:0] HRESP,
    output reg HREADY_M0,
    output reg HREADY_M1,
    output reg HREADY_M2,
    output reg HREADY_M3,
    output reg [31:0] HRDATA_M0,
    output reg [31:0] HRDATA_M1,
    output reg [31:0] HRDATA_M2,
    output reg [31:0] HRDATA_M3,
    output reg [1:0] HRESP_M0,
    output reg [1:0] HRESP_M1,
    output reg [1:0] HRESP_M2,
    output reg [1:0] HRESP_M3
);

//HMASTER[3:0]
parameter M0 = 0;
parameter M1 = 1;
parameter M2 = 2;
parameter M3 = 3;

always @* begin
    case(HMASTER)
    M1: begin
        HREADY_M1 <= HREADY;
        HRDATA_M1 <= HRDATA;
        HRESP_M1 <= HRESP;
    end
    M2: begin
        HREADY_M2 <= HREADY;
        HRDATA_M2 <= HRDATA;
        HRESP_M2 <= HRESP;
    end
    M3: begin
        HREADY_M3 <= HREADY;
        HRDATA_M3 <= HRDATA;
        HRESP_M3 <= HRESP;
    end
    default: begin
        HREADY_M0 <= HREADY;
        HRDATA_M0 <= HRDATA;
        HRESP_M0 <= HRESP;
    end
    endcase
end

endmodule