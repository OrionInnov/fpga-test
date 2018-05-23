`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: 江凯都
//
// Description:
//
// Revision: N/A
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////


module clk_division #(
  parameter [19:0] DECIMATION = 20'd16) (
  reset,
  clk,
  clken
);

input           clk;
input           reset;
output          clken;

reg             _clken;
(*keep="true"*) reg [19:0] cycle = 0;

assign clken = _clken;

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
    _clken <= 1'b0;
  end else if (cycle == DECIMATION - 20'b1) begin
    _clken <= 1'b1;
  end else begin
    _clken <= 1'b0;
  end
end

endmodule
