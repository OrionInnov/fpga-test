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


module Fibonacci #(
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

wire           clken;
wire           clk_reset;
reg     [7:0]  a,b;

assign out = b;
 
always @(posedge clk) begin
  if(reset) begin
    a <= 8'b0;
    b <= 8'b1;
  end else if (clken) begin
    a <= b;
    b <= a + b;
  end else begin
    a <= a;
    b <= b;
  end
end

clk_division #(
  .DECIMATION(DECIMATION)) fibclk(
  .reset(clk_reset),
  .clk(clk),
  .clken(clken)
);

endmodule


