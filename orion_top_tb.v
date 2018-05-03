`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/20 10:46:57
// Design Name: 
// Module Name: toptest
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


module toptest;
reg             clk;
reg             reset;
reg             ren;
reg             cs_mem;
reg     [15:0]  dina;
reg     [18:0]  read_addr;


wire            done;
wire    [15:0]  data_tomcu;
wire    [15:0]  dina1;
wire    [15:0]  dina2;
wire    [15:0]  dinb1;
wire    [15:0]  dinb2;
wire    [18:0]  test_addr1;
wire    [18:0]  test_addr2;
wire    [19:0]  testcycle;
wire    [ 1:0]  testcycle1;

parameter _dina = 16'b0101010101010101;
parameter _addr = 19'b0;

assign dina1 = dina;
assign dina2 = dina + 1000;
assign dinb1 = dina + 2000;
assign dinb2 = dina + 3000;

always #5 clk = ~clk;

initial begin
  reset = 0;
  clk = 0;
  ren = 1;
  cs_mem = 1;
  #20 reset = ~reset;
  #40 reset = ~reset;
  #400 reset = ~reset;
  #40 reset = ~reset;
  #243 reset = ~reset;
  #40 reset = ~reset;
end

always @ (posedge clk) begin
  if (reset) begin dina <= _dina; ren = 1; read_addr <= _addr; end
  else if (done) begin
    ren <= 0;
  end else begin
    #20 dina <= dina + 22;
  end
end
always @ (posedge clk) begin
  if (done) begin
    read_addr <= _addr;
  end else if (read_addr <= 50 && ren == 0) begin
    #30 read_addr <= read_addr + 1;
  end else if (read_addr > 50 && ren == 0) begin
    read_addr <= 19'b0;
  end else begin
    read_addr <= read_addr;
  end
end


top topT(
    .read_addr(read_addr),
    .clk(clk),
    .reset(reset),
    .dina1(dina1),
    .dina2(dina2),
    .dinb1(dinb1),
    .dinb2(dinb2),
    .ren(ren),
    .cs_mem(cs_mem),
    .data_tomcu(data_tomcu),
    .done(done),
    .test_addr1(test_addr1),
    .test_addr2(test_addr2),
    .testcycle(testcycle),
    .testcycle1(testcycle1)
);
endmodule