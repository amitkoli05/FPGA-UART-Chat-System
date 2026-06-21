module usart_tx(
input clk,
input rst,
input [7:0] tx_data,
input tx_start,

    output reg tx,
    output reg tx_done
);

parameter BAUD_DIV = 10;

reg [12:0] baud_cnt;
reg baud_tick;

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;


// Baud Generator
always @(posedge clk or posedge rst)
begin
if(rst)
begin
baud_cnt  <= 0;
baud_tick <= 0;
end
else if(baud_cnt == BAUD_DIV-1)
begin
baud_cnt  <= 0;
baud_tick <= 1;
end
else
begin
baud_cnt  <= baud_cnt + 1;
baud_tick <= 0;
end
end


// FSM
always @(posedge clk or posedge rst)
begin
if(rst)
 begin
state <= IDLE;
tx <= 1;
tx_done <= 0;
bit_index <= 0;
data_reg <= 0;
end
else
begin

case(state)

 IDLE:
begin
tx <= 1;
tx_done <= 0;

if(tx_start)
begin
data_reg <= tx_data;
state <= START;
end
end

 START:
begin
if(baud_tick)
begin
tx <= 0;
bit_index <= 0;
state <= DATA;
 end
end

 DATA:
begin
if(baud_tick)
begin
tx <= data_reg[bit_index];

if(bit_index == 7)
state <= STOP;
else
bit_index <= bit_index + 1;
end
end

STOP:
begin
if(baud_tick)
begin
tx <= 1;
tx_done <= 1;
state <= IDLE;
end
end

endcase
end
end

endmodule
