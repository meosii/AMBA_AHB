`ifndef AHB_DEFINE
`define AHB_DEFINE

//HTRANS[1:0]
`define IDLE 2'b00
`define BUSY 2'b01
`define NONSEQ 2'b10
`define SEQ 2'b11
//HBURST[2:0]
`define SINGLE 3'b000
`define INCR 3'b001
`define WRAP4 3'b010
`define INCR4 3'b011
`define WRAP8 3'b100
`define INCR8 3'b101
`define WRAP16 3'b110
`define INCR16 3'b111
//HRESP[1:0]
`define OKAY 2'b00
`define ERROR 2'b01
`define RETRY 2'b10
`define SPLIT 2'b11
//HSIZE[2:0]
`define HSIZE_8    3'b000
`define HSIZE_16   3'b001
`define HSIZE_32   3'b010
`define HSIZE_64   3'b011
`define HSIZE_128  3'b100
`define HSIZE_256  3'b101
`define HSIZE_512  3'b110
`define HSIZE_1024 3'b111

`endif