`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/21 09:53:44
// Design Name: 
// Module Name: testLED
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


module testLED;

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