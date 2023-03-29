//  Memory map:
//  0x00000000 - 0x0FFFFFFF is for slave 1
//  0x10000000 - 0x1FFFFFFF is for slave 2
//  0x20000000 - 0x2FFFFFFF is for slave 3
//  0x30000000 - 0x3FFFFFFF is for slave 4
//  0x40000000 - 0x4FFFFFFF is for slave 5
//  0x50000000 - 0x5FFFFFFF is for slave 6

module decoder (
    input wire [31:0] HADDR,
    output reg HSELx0,
    output reg HSELx1,
    output reg HSELx2,
    output reg HSELx3,
    output reg HSELx4,
    output reg HSELx5,
    output reg HSELx6
);

parameter HSELx1_ADDR = 4'b0000;
parameter HSELx2_ADDR = 4'b0001;
parameter HSELx3_ADDR = 4'b0010;
parameter HSELx4_ADDR = 4'b0011;
parameter HSELx5_ADDR = 4'b0100;
parameter HSELx6_ADDR = 4'b0101;

always @* begin
    // Assigning initial value first to avoid inferred latches
    HSELx0 = 1'b0;
    HSELx1 = 1'b0;
    HSELx2 = 1'b0;
    HSELx3 = 1'b0;
    HSELx4 = 1'b0;
    HSELx5 = 1'b0;
    HSELx6 = 1'b0;
    case(HADDR[31:28])
    HSELx1_ADDR: begin
        HSELx0 = 1'b0;
        HSELx1 = 1'b1;
        HSELx2 = 1'b0;
        HSELx3 = 1'b0;
        HSELx4 = 1'b0;
        HSELx5 = 1'b0;
        HSELx6 = 1'b0;
    end
    HSELx2_ADDR: begin
        HSELx0 = 1'b0;
        HSELx1 = 1'b0;
        HSELx2 = 1'b1;
        HSELx3 = 1'b0;
        HSELx4 = 1'b0;
        HSELx5 = 1'b0;
        HSELx6 = 1'b0;
    end
    HSELx3_ADDR: begin
        HSELx0 = 1'b0;
        HSELx1 = 1'b0;
        HSELx2 = 1'b0;
        HSELx3 = 1'b1;
        HSELx4 = 1'b0;
        HSELx5 = 1'b0;
        HSELx6 = 1'b0;
    end
    HSELx4_ADDR: begin
        HSELx0 = 1'b0;
        HSELx1 = 1'b0;
        HSELx2 = 1'b0;
        HSELx3 = 1'b0;
        HSELx4 = 1'b1;
        HSELx5 = 1'b0;
        HSELx6 = 1'b0;
    end
    HSELx5_ADDR: begin
        HSELx0 = 1'b0;
        HSELx1 = 1'b0;
        HSELx2 = 1'b0;
        HSELx3 = 1'b0;
        HSELx4 = 1'b0;
        HSELx5 = 1'b1;
        HSELx6 = 1'b0;
    end
    HSELx6_ADDR: begin
        HSELx0 = 1'b0;
        HSELx1 = 1'b0;
        HSELx2 = 1'b0;
        HSELx3 = 1'b0;
        HSELx4 = 1'b0;
        HSELx5 = 1'b0;
        HSELx6 = 1'b1;
    end
    default: begin
        HSELx0 = 1'b1; //default_slave
        HSELx1 = 1'b0;
        HSELx2 = 1'b0;
        HSELx3 = 1'b0;
        HSELx4 = 1'b0;
        HSELx5 = 1'b0;
        HSELx6 = 1'b0;
    end
    endcase
end
    
endmodule