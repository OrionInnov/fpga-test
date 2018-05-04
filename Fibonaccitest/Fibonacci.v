`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/20 16:56:51
// Design Name: 
// Module Name: 
// Project Name: Fibonacci
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fibonacci # (
  parameter DECIMATION = 20'd16) (
  clk_reset,
  reset,
  clk,
  out
);

input          clk_reset;
input          clk;
input          reset;
output  [7:0]  out;

wire           fib_clk;
wire           clk_reset;
reg     [7:0]  a,b;

parameter DECIMATION0 = DECIMATION / 2;

assign out = b;
 
always @(posedge fib_clk) begin
  if(reset) begin
    a <= 8'b0;
    b <= 8'b1;
  end else begin
    a <= b;
    b <= a + b;
	end
end

clk_division #(
  .DECIMATION(DECIMATION0)) fibclk(
  .reset(clk_reset),
  .clk(clk),
  .out_clk(fib_clk)
);

endmodule


