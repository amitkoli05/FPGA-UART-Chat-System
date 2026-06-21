module uart_RX(
 input clk,
 input rst,
 input rx,

 output reg [7:0] rx_data,
    output reg rx_done
);

parameter BAUD_DIV = 10;

reg [12:0] baud_cnt;
reg baud_tick;

reg [1:0] state;
reg [2:0] bit_cnt;
reg [7:0] shift_reg;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;


// Baud Generator
always @(posedge clk or posedge rst)
begin
if(rst)
begin
baud_cnt <= 0;
baud_tick <= 0;
end
else if(baud_cnt == BAUD_DIV-1)
begin
baud_cnt <= 0;
baud_tick <= 1;
end
else
begin
baud_cnt <= baud_cnt + 1;
baud_tick <= 0;
end
end


always @(posedge clk or posedge rst)
begin
if(rst)
begin
state <= IDLE;
bit_cnt <= 0;
shift_reg <= 0;
rx_data <= 0;
rx_done <= 0;
end
else
begin
case(state)

IDLE:
begin
rx_done <= 0;

if(rx == 0)
state <= START;
end

START:
begin
if(baud_tick)
begin
bit_cnt <= 0;
state <= DATA;
end
end

DATA:
begin
if(baud_tick)
begin
shift_reg[bit_cnt] <= rx;

if(bit_cnt == 7)
state <= STOP;
else
bit_cnt <= bit_cnt + 1;
end
end

STOP:
begin
if(baud_tick)
begin
rx_data <= shift_reg;
rx_done <= 1;
state <= IDLE;
end
end

endcase
end
end

endmodule
//NEW
