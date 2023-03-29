//AHB master-to-slave multiplexer

module mux_m2s (
    //Input pins
    //master0
    input wire [31:0] HADDRx0,
    input wire [1:0] HTRANSx0,
    input wire HWRITEx0,
    input wire [2:0] HSIZEx0,
    input wire [2:0] HBURSTx0,
    input wire [3:0] HPROTx0,
    input wire [31:0] HWDATAx0,
    //master1
    input wire [31:0] HADDRx1,
    input wire [1:0] HTRANSx1,
    input wire HWRITEx1,
    input wire [2:0] HSIZEx1,
    input wire [2:0] HBURSTx1,
    input wire [3:0] HPROTx1,
    input wire [31:0] HWDATAx1,
    //master2
    input wire [31:0] HADDRx2,
    input wire [1:0] HTRANSx2,
    input wire HWRITEx2,
    input wire [2:0] HSIZEx2,
    input wire [2:0] HBURSTx2,
    input wire [3:0] HPROTx2,
    input wire [31:0] HWDATAx2,
    //master3
    input wire [31:0] HADDRx3,
    input wire [1:0] HTRANSx3,
    input wire HWRITEx3,
    input wire [2:0] HSIZEx3,
    input wire [2:0] HBURSTx3,
    input wire [3:0] HPROTx3,
    input wire [31:0] HWDATAx3,

    //Select signals
    input wire [3:0] HMASTER,
    input wire [3:0] HMASTERD,

    //Output pins
    output reg [31:0] HADDR,
    output reg [1:0] HTRANS,
    output reg HWRITE,
    output reg [2:0] HSIZE,
    output reg [2:0] HBURST,
    output reg [3:0] HPROT,
    output reg [31:0] HWDATA
);

parameter HMASTER_M0 = 0;
parameter HMASTER_M1 = 0;
parameter HMASTER_M2 = 0;
parameter HMASTER_M3 = 0;

always @* begin
    case(HMASTER)
    HMASTER_M0: begin
    HADDR = HADDRx0;
    HTRANS = HTRANSx0;
    HWRITE = HWRITEx0;
    HSIZE = HSIZEx0;
    HBURST = HBURSTx0;
    HPROT = HPROTx0;
    HWDATA = HWDATAx0;
    end
    HMASTER_M1: begin
    HADDR = HADDRx1;
    HTRANS = HTRANSx1;
    HWRITE = HWRITEx1;
    HSIZE = HSIZEx1;
    HBURST = HBURSTx1;
    HPROT = HPROTx1;
    HWDATA = HWDATAx1;
    end
    HMASTER_M0: begin
    HADDR = HADDRx2;
    HTRANS = HTRANSx2;
    HWRITE = HWRITEx2;
    HSIZE = HSIZEx2;
    HBURST = HBURSTx2;
    HPROT = HPROTx2;
    HWDATA = HWDATAx2;
    end
    HMASTER_M0: begin
    HADDR = HADDRx3;
    HTRANS = HTRANSx3;
    HWRITE = HWRITEx3;
    HSIZE = HSIZEx3;
    HBURST = HBURSTx3;
    HPROT = HPROTx3;
    HWDATA = HWDATAx3;
    end
    default : begin
    HADDR = HADDRx0;
    HTRANS = HTRANSx0;
    HWRITE = HWRITEx0;
    HSIZE = HSIZEx0;
    HBURST = HBURSTx0;
    HPROT = HPROTx0;
    HWDATA = HWDATAx0;
    end
    endcase
end
    
endmodule