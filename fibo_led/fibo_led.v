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


module fibo_led #(
  parameter DECIMATION = 20'd16) (
  reset,
  clk,
  out
);

input          clk;
input          reset;
output  [7:0]  out;

wire           clken;
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
  .reset(reset),
  .clk(clk),
  .clken(clken)
);

endmodule
