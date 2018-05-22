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


module count_led_tb;

reg             clk;
reg             reset;

wire    [ 9:0]  runled;

always #5 clk = ~clk;

initial begin
    reset = 0;
    clk = 0;
    #20 reset = ~reset;
    #40 reset = ~reset;
end

LED #(
  .DECIMATION(20'd20)) LEDT(
  .reset(reset),
  .clk(clk),
  .runled(runled)
);
endmodule
