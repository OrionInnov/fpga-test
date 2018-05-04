`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/04 10:17:55
// Design Name: 
// Module Name: clk_division
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


module clk_division #(
  parameter [19:0] DECIMATION = 20'd16) (
  reset,
  clk,
  out_clk
);

input           clk;
input           reset;
output          out_clk;

reg             _out_clk;
(*keep="true"*) reg [19:0] cycle = 0;

assign out_clk = _out_clk;

always @ (posedge clk) begin
  if (reset) begin
    cycle <= 20'b0;
  end else if (cycle == DECIMATION - 20'b1) begin
    cycle <= 20'b0;
  end else begin
    cycle <= cycle + 20'b1;
  end
end

always @ (posedge clk) begin
  if (reset) begin
    _out_clk <= 1'b0;
  end else if (cycle == DECIMATION - 20'b1) begin
    _out_clk <= ~_out_clk;
  end else begin
    _out_clk <= _out_clk;
  end
end

endmodule