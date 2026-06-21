`timescale 1ns/1ps

module tb_tx;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_done;

usart_tx #(
    .BAUD_DIV(10)
)
TX(
    .clk(clk),
    .rst(rst),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .tx(tx),
    .tx_done(tx_done)
);

// Clock
always #5 clk = ~clk;

initial
begin
    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 0;

    #20;
    rst = 0;

    #20;

    tx_data = 8'h41;
    tx_start = 1;

    #20;
    tx_start = 0;

    #2000;

    $stop;
end

endmodule
// NEW
