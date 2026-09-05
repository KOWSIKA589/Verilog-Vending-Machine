module newsven(
    input x,
    output reg y1,
    input clk,
    input reset
);

reg y;

parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;

reg [1:0] p_s;
reg [1:0] n_s;

always @(posedge clk, posedge reset)
begin
    if (reset)
    begin
        p_s <= s0;
        y1 <= 1'b0;
    end
    else
    begin
        p_s <= n_s;
        y1 <= y;
    end
end

always @(p_s, x)
begin
    case(p_s)

        s0:
        if(x == 0)       // 0 = nickel (5 cents)
        begin
            n_s <= s1;
            y = 1'b0;
        end
        else if(x == 1)  // 1 = dime (10 cents)
        begin
            n_s <= s2;
            y = 1'b0;
        end
        else
        begin
            n_s <= s0;
            y = 1'b0;
        end

        s1:
        if(x == 0)
        begin
            n_s <= s2;
            y = 1'b0;
        end
        else if(x == 1)
        begin
            n_s <= s0;
            y = 1'b1;
        end
        else
        begin
            n_s <= s1;
            y = 1'b0;
        end

        s2:
        if((x == 0) || (x == 1))
        begin
            n_s <= s0;
            y = 1'b1;
        end
        else
        begin
            n_s <= s2;
            y = 1'b0;
        end

        default:
        begin
            n_s <= s0;
            y = 1'b0;
        end

    endcase
end

endmodule
module newsven_tb;

reg clk;
reg reset;
reg x;

wire y1;

newsven uut (
    .x(x),
    .y1(y1),
    .clk(clk),
    .reset(reset)
);

initial
begin
    clk = 1'b0;
    reset = 1'b1;
    x = 1'b0;

    #10 reset = 1'b0;

    #10 x = 1'b1;
    #10 x = 1'b0;
    #10 x = 1'b0;
    #10 x = 1'b0;
    #10 x = 1'b1;
    #10 x = 1'b1;

    #10 $finish;
end

always
begin
    #5 clk = ~clk;
end

endmodule