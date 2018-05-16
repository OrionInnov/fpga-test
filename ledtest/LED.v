`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/20 16:56:51
// Design Name: 
// Module Name: LED
// Project Name: 
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


module LED #(
  parameter [19:0] DECIMATION = 20'd16) (
  reset,
  clk,
  runled
);


input           clk;
input           reset;
output  [ 9:0]  runled;

wire            enable;
(*keep="true"*) reg [9:0] _runled = 0;
 
parameter [19:0] DECIMATION0 = DECIMATION / 2;

assign runled = _runled;

always @ (posedge clk) begin
  if (reset) begin
    _runled <= 10'b0;
  end else if (enable) begin
    _runled <= _runled + 10'b1;
  end else begin
    _runled <= _runled;
  end
end

clk_division #(
  .DECIMATION(DECIMATION0)) led_clk(
  .reset(reset),
  .clk(clk),
  .enable(enable)
);

endmodule