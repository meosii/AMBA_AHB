`include "arbiter.v"
`include "define.v"
`timescale 1ps/1ps

module test_arbiter();
reg HCLK;
reg HRESETn;
reg [2:0] HBUSREQ;
reg [2:0] HLOCK;
reg [31:0] HADDR;
reg [2:0] HSPLIT;
reg [1:0] HTRANS;
reg [2:0] HBURST;
reg [1:0] HRESP;
reg HREADY;
wire [1:0] HMASTER;
wire HMASTLOCK;
wire [2:0] HGRANT;

arbiter arbiter_0(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HBUSREQ(HBUSREQ),
    .HLOCK(HLOCK),
    .HADDR(HADDR),
    .HSPLIT(HSPLIT),
    .HTRANS(HTRANS),
    .HBURST(HBURST),
    .HRESP(HRESP),
    .HREADY(HREADY),
    .HMASTER(HMASTER),
    .HMASTLOCK(HMASTLOCK),
    .HGRANT(HGRANT)
);

always #5 HCLK = ~HCLK;

initial fork
    #0 begin
        HCLK = 0;
        HRESETn = 0;
    end
    #2 begin
        HRESETn = 1;
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
        HSPLIT = 3'b000;
        HTRANS = `IDLE;
        HBURST = `SINGLE;
        HRESP = `OKAY;
        HREADY = 1;
    end
    // 当主机被赋予总线使用权，只需给一个REQ
    #12 begin
        HBUSREQ = 3'b010;
        HLOCK = 3'b010;
    end
    #22 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
    end
    #25 begin
        HTRANS = `NONSEQ;
        HBURST = `INCR4;
        HRESP = `OKAY;
        HSPLIT = 3'b000;
        // HREADY = 1;
    end
    #35 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ;
        HBURST = `INCR4;
        HRESP = `OKAY;
        HREADY = 1;
    end
    //当被LOCK，不再接收其他REQ
    #52 begin
        HBUSREQ = 3'b001;
        HLOCK = 3'b001;
    end
    #62 begin
        HBUSREQ = 3'b110;
        HLOCK = 3'b110;
    end
    #72 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
    end
    #75 begin
        HSPLIT = 3'b000;
        HTRANS = `NONSEQ;
        HBURST = `INCR4;
        HRESP = `OKAY;
        HREADY = 1;
    end
    #85 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ;
        HBURST = `INCR4;
        HRESP = `OKAY;
        HREADY = 1;
    end
    //RETRY
    #95 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ;
        HBURST = `INCR4;
        HRESP = `RETRY;
        HREADY = 0;
    end
    #105 begin
        HBUSREQ = 3'b100; //主机重新发送请求
        HLOCK = 3'b100;
        HSPLIT = 3'b000;
        HTRANS = `IDLE;
        HBURST = `INCR4;
        HRESP = `RETRY; //RETRY要两个时钟周期
        HREADY = 1;
    end
    #115 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
        HSPLIT = 3'b000;
        HTRANS = `NONSEQ; //RETRY一次新传输
        HBURST = `INCR4;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #125 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ; 
        HBURST = `INCR4;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    //SPLIT
    #172 begin
        HBUSREQ = 3'b010;
        HLOCK = 3'b010;
    end
    #182 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
    end
    #185 begin
        HSPLIT = 3'b000;
        HTRANS = `NONSEQ; 
        HBURST = `INCR4;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #195 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ; 
        HBURST = `INCR4;
        HRESP = `SPLIT; 
        HREADY = 0;
    end
    #205 begin
        HBUSREQ = 3'b100; //检测SPLIT
        HLOCK = 3'b100;
        HSPLIT = 3'b000;
        HTRANS = `IDLE; 
        HBURST = `INCR8;
        HRESP = `SPLIT; 
        HREADY = 1;
    end
    #215 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
        HSPLIT = 3'b000;
        HTRANS = `NONSEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #225 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
        HSPLIT = 3'b000;
        HTRANS = `SEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #300 begin
        HSPLIT = 3'b001;
    end
    #305 begin
        HBUSREQ = 3'b001;
        HLOCK = 3'b001;
    end
    #316 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
    end
    #325 begin
        HSPLIT = 3'b000;
        HTRANS = `NONSEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #335 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #345 begin
        HBUSREQ = 3'b100;
        HLOCK = 3'b000;
        HSPLIT = 3'b000;
        HTRANS = `SEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #365 begin
        HBUSREQ = 3'b000;
        HLOCK = 3'b000;
        HSPLIT = 3'b000;
        HTRANS = `NONSEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #375 begin
        HSPLIT = 3'b000;
        HTRANS = `SEQ; 
        HBURST = `INCR8;
        HRESP = `OKAY; 
        HREADY = 1;
    end
    #450 $finish;
join

initial begin
    $dumpfile("wave_arbiter.vcd");
    $dumpvars(0,test_arbiter);
end

endmodule