`include "define.v"
module arbiter(
    input wire HCLK,
    input wire HRESETn,
    //arbiter request and locks
    input wire [2:0] HBUSREQ,
    input wire [2:0] HLOCK,
    //Address and control
    input wire [31:0] HADDR,
    input wire [2:0] HSPLIT,
    input wire [1:0] HTRANS,
    input wire [2:0] HBURST,
    input wire [1:0] HRESP,
    input wire HREADY,
    // Signal for slaves
    output reg [1:0] HMASTER,
    output reg HMASTLOCK,
    //arbiter grants
    output reg [2:0] HGRANT
);

//grant    
parameter GRANT_M0 = 0;
parameter GRANT_M1 = 1;
parameter GRANT_M2 = 2;
parameter GRANT_DUMMY = 3;
//HMASTER[1:0]
parameter M0 = 2'b00;
parameter M1 = 2'b01;
parameter M2 = 2'b10;
parameter M_DUMMY = 2'b11;

reg [1:0] grant;
reg [1:0] next_grant;
reg [2:0] queue_0;//highest priority queue
reg [2:0] next_queue_0;
reg [6:0] count;
reg finish_0; //通过count为0不能判断是否应该转让优先级，因为当count=0保持两个周期，即在下一个grant分配时的count还是0，导致该主机还没执行就被下一级代替
reg [2:0] mastlock_0;
reg [2:0] mastlock_1;
reg mastlock;
reg lock;

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        queue_0 <= 3'b111;
        next_queue_0 <= 3'b111;
    end else begin
        queue_0 <= next_queue_0;
    end
end

always @* begin
    if (HSPLIT != 0) begin
        next_queue_0 <= HSPLIT | queue_0;
    end else begin
        next_queue_0 <= next_queue_0;
    end
    case(grant)
        GRANT_M0: begin
            if (HRESP == `SPLIT) begin
                next_queue_0[0] <= 1'b0;
            end else begin
                next_queue_0[0] <= next_queue_0[0];
            end
        end
        GRANT_M1: begin
            if (HRESP == `SPLIT) begin
                next_queue_0[1] <= 1'b0;
            end else begin
                next_queue_0[1] <= next_queue_0[1];
            end
        end
        GRANT_M2: begin
            if (HRESP == `SPLIT) begin
                next_queue_0[2] <= 1'b0;
            end else begin
                next_queue_0[2] <= next_queue_0[2];
            end
        end
        default: next_queue_0 <= next_queue_0;
    endcase
end

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        grant <= GRANT_DUMMY;
    end else begin
        grant <= next_grant;
    end
end

always @* begin
    case(grant)
    GRANT_M0: begin
        if ((HRESP == `OKAY) | (HRESP == `ERROR)) begin
            if (!finish_0 && lock) begin
                next_grant <= GRANT_M0;
            end else begin
                if (next_queue_0[1] && HBUSREQ[1]) begin
                    next_grant <= GRANT_M1;
                end else if (next_queue_0[2] && HBUSREQ[2]) begin
                    next_grant <= GRANT_M2;
                end else begin
                    next_grant <= GRANT_M0;
                end
            end
        end else if (HRESP == `SPLIT) begin
            if (next_queue_0[1] && HBUSREQ[1]) begin
                next_grant <= GRANT_M1;
            end else if (next_queue_0[2] && HBUSREQ[2]) begin
                next_grant <= GRANT_M2;
            end else begin
                next_grant <= GRANT_DUMMY;
            end
        end else begin //HRESP == `RETRY
            next_grant <= GRANT_M0;
        end
    end
    GRANT_M1: begin
        if ((HRESP == `OKAY) | (HRESP == `ERROR)) begin
            if (!finish_0 && lock) begin
                next_grant <= GRANT_M1;
            end else begin
                if (next_queue_0[2] && HBUSREQ[2]) begin
                    next_grant <= GRANT_M2;
                end else if (next_queue_0[0] && HBUSREQ[0]) begin
                    next_grant <= GRANT_M0;
                end else begin
                    next_grant <= GRANT_M1;
                end
            end
        end else if (HRESP == `SPLIT) begin
            if (next_queue_0[2] && HBUSREQ[2]) begin
                next_grant <= GRANT_M2;
            end else if (next_queue_0[0] && HBUSREQ[0]) begin
                next_grant <= GRANT_M0;
            end else begin
                next_grant <= GRANT_DUMMY;
            end
        end else begin
            next_grant <= GRANT_M1;
        end
    end
    GRANT_M2: begin
        if ((HRESP == `OKAY) | (HRESP == `ERROR)) begin
            if (!finish_0 && lock) begin
                next_grant <= GRANT_M2;
            end else begin
                if (next_queue_0[0] && HBUSREQ[0]) begin
                    next_grant <= GRANT_M0;
                end else if (next_queue_0[1] && HBUSREQ[1]) begin
                    next_grant <= GRANT_M1;
                end else begin
                    next_grant <= GRANT_M2;
                end
            end
        end else if (HRESP == `SPLIT) begin
            if (next_queue_0[0] && HBUSREQ[0]) begin
                next_grant <= GRANT_M0;
            end else if (next_queue_0[1] && HBUSREQ[1]) begin
                next_grant <= GRANT_M1;
            end else begin
                next_grant <= GRANT_DUMMY;
            end
        end else begin
            next_grant <= GRANT_M2;
        end
    end
    default: begin
        if (next_queue_0[0] && HBUSREQ[0]) begin
            next_grant <= GRANT_M0;
        end else if (next_queue_0[1] && HBUSREQ[1]) begin
            next_grant <= GRANT_M1;
        end else if (next_queue_0[2] && HBUSREQ[2]) begin
            next_grant <= GRANT_M2;
        end else begin
            next_grant <= GRANT_DUMMY;
        end
    end
    endcase
end

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        mastlock_0 <= 3'b000;
    end else begin
        if (HBUSREQ[0] && HLOCK[0]) begin
            mastlock_0[0] <= 1;
        end else begin
            mastlock_0[0] <= 0;
        end
        if (HBUSREQ[1] && HLOCK[1]) begin
            mastlock_0[1] <= 1;
        end else begin
            mastlock_0[1] <= 0;
        end
        if (HBUSREQ[2] && HLOCK[2]) begin
            mastlock_0[2] <= 1;
        end else begin
            mastlock_0[2] <= 0;
        end
    end
end

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        mastlock_1 <= 3'b000;
    end else begin
        case(grant)
            GRANT_M0: begin
                if (mastlock_0[0]) begin
                    mastlock_1[0] <= 1;
                end else begin
                    mastlock_1[0] <= 0;
                end
                mastlock_1[2:1] <= 2'b00;
            end
            GRANT_M1: begin
                if (mastlock_0[1]) begin
                    mastlock_1[1] <= 1;
                end else begin
                    mastlock_1[1] <= 0;
                end
                mastlock_1[2] <= 0;
                mastlock_1[0] <= 0;
            end
            GRANT_M2: begin
                if (mastlock_0[2]) begin
                    mastlock_1[2] <= 1;
                end else begin
                    mastlock_1[2] <= 0;
                end
                mastlock_1[1:0] <= 2'b00;
            end
            default: mastlock_1 <= 3'b000;
        endcase
    end
end

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        mastlock <= 0;
    end else begin
        if (mastlock_1 != 3'b000) begin
            mastlock <= 1;
        end else if (count == 0) begin
            mastlock <= 0;
        end else begin
            mastlock <= mastlock;
        end
    end
end

always @* begin
    HMASTLOCK <= mastlock_1[0] || mastlock_1[1] || mastlock_1[2];
    lock <= mastlock || HMASTLOCK || ((grant == GRANT_M0) && mastlock_0[0]) || ((grant == GRANT_M1) && mastlock_0[1]) || ((grant == GRANT_M2) && mastlock_0[2]);
end

always @* begin
    case (grant)
        GRANT_M0: HGRANT <= 3'b001;
        GRANT_M1: HGRANT <= 3'b010;
        GRANT_M2: HGRANT <= 3'b100;
        default: HGRANT <= 3'b000;
    endcase
end

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        HMASTER <= 2'b00;
    end else begin
        if (HREADY) begin
            case (grant)
                GRANT_M0: HMASTER <= M0;
                GRANT_M1: HMASTER <= M1;
                GRANT_M2: HMASTER <= M2; 
                default: HMASTER <= M_DUMMY;
            endcase
        end else begin
            HMASTER <= HMASTER;
        end
    end
end
 
always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        count <= 0;
        finish_0 <= 0;
    end else begin
        if (HTRANS == `NONSEQ) begin
            case (HBURST)
                `SINGLE: count <= 0;
                `INCR: count <= 20;
                `WRAP4: count <= 3;
                `INCR4: count <= 3;
                `WRAP8: count <= 7;
                `INCR8: count <= 7;
                `WRAP16: count <= 15;
                `INCR16: count <= 15;
                default: count <= 0; 
            endcase
        end else if (HTRANS == `SEQ) begin
            if (HREADY) begin
                if (count == 1) begin
                    finish_0 <= 1;
                end else begin
                    finish_0 <= 0;
                end
                if (count != 0) begin
                    count <= count - 1;
                end else begin
                    count <= 0;
                end
            end else begin
                if (HRESP == `SPLIT) begin
                    count <= 0;
                end else if (HRESP == `RETRY) begin
                    count <= 0; //count will be reset when `NONSEQ
                end else begin //`ERROR
                    count <= count;
                end
            end
        end else if (HTRANS == `IDLE) begin
            count <= 0;
        end else begin //`BUSY
            count <= count;
        end
    end
end

endmodule