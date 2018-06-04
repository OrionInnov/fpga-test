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


module fibo_led_tb;

reg             clk;
reg             reset;

wire    [ 7:0]  out;

always #5 clk = ~clk;

initial begin
  reset = 0;
  clk = 0;
  #20 reset = ~reset;
  #1000 reset = ~reset;
end

fibo_led #(
  .DECIMATION(20'd20)
) fibo_led (
  .reset(reset),
  .clk(clk),
  .out(out)
);
endmodule
