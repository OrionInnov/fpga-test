`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/16 16:21:45
// Design Name: 
// Module Name: top
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


module top(
  read_addr,
  clk,
  reset,
  dina1,
  dina2,
  dinb1,
  dinb2,
  ren,
  cs_mem,
  data_tomcu,
  done,
  test_addr1,
  test_addr2,
  testcycle,
  testcycle1
);

input           clk;
input           reset;
input           ren;
input           cs_mem;
input   [18:0]  read_addr;
input   [15:0]  dina1;
input   [15:0]  dina2;
input   [15:0]  dinb1;
input   [15:0]  dinb2;

output          done;
output  [15:0]  data_tomcu;
output  [18:0]  test_addr1;
output  [18:0]  test_addr2;
output  [19:0]  testcycle;
output  [ 1:0]  testcycle1;

wire            ena;
wire            wea;
wire    [15:0]  _data_tomcu;
wire    [15:0]  _data_tomcua;
wire    [15:0]  _data_tomcub;
wire    [18:0]  _addr1;
wire    [18:0]  _addr2;
wire    [18:0]  addr1;
wire    [18:0]  addr2;
wire    [15:0]  doutb1;
wire    [15:0]  doutb2;

reg     [18:0]  addr0;

(*keep="true"*) reg _ena;
(*keep="true"*) reg _wea;
/*(*keep="true"*)*/ reg _done;
/*(*keep="true"*)*/ reg [19:0] cycle;
/*(*keep="true"*)*/ reg [ 1:0] cycle1;


assign ena = _ena;
assign wea = _wea;
assign _addr1 = (_wea == 1'b1) ? addr1 : read_addr;
assign _addr2 = (_wea == 1'b1) ? addr2 : read_addr;
assign addr1 = addr0;
assign addr2 = addr0 + 176128;
assign data_tomcu = (~ren && ~done) ? _data_tomcu : 16'h0;
assign _data_tomcu = (~cs_mem) ? _data_tomcua : _data_tomcub;
assign done = _done;
assign doutb1 = 0;
assign doutb2 = 0;
assign test_addr1 = _addr1;
assign test_addr2 = _addr2;
assign testcycle = cycle;
assign testcycle1 = cycle1;




always @ (posedge clk) begin
  if (reset) begin
    cycle <= 20'b00_000000_000000_000000;
  end else if (done && (cycle > 20'b00_000000_000000_000010)) begin
    cycle <= 20'b00_000000_000000_000000;
  end else begin
    cycle <= cycle + 20'b00_000000_000000_000001;
  end
end

always @ (posedge clk) begin
  if (reset) begin
    cycle1 <= 2'b00;
  end else if (cycle1 == 2'b01) begin
    cycle1 <= 2'b00;
  end else begin
    cycle1 <= cycle1 + 2'b01;
  end
end

//计数器模块



always @ (posedge clk) begin
  if (reset) begin
    {_ena, _wea} <= 2'b11;
    addr0 <= 19'b0;
    _done <= 1'b0;
  end else begin
    casex({cycle, _ena, _wea})
      23'b????????????????????11: begin
          
        if (addr0 > 176126) begin
          {_ena, _wea} <= 2'b10;
          _done <= 1'b1;
          addr0 <= 0;
        end else if (addr0 <= 176126 && cycle1 == 2'b00 && cycle > 1) begin
          {_ena, _wea} <= {_ena, _wea};
          addr0 <= addr0 + 19'b0_000000_000000_000001;
          _done <= _done;
        end else begin
          {_ena, _wea} <= {_ena, _wea};
          addr0 <= addr0;
          _done <= _done;
        end
      end
      23'b0000000000000000001110: begin
        {_ena, _wea} <= {_ena, _wea};
        addr0 <= addr0;
        _done <= 1'b0;
      end
      default: begin
        {_ena, _wea} <= {_ena, _wea};
        addr0 <= addr0;
        _done <= _done;
      end
    endcase
  end
end


blockMemTopA blockTopA (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(_addr1),  // input wire [18 : 0] addra
  .dina(dina1),    // input wire [15 : 0] dina
  .douta(_data_tomcua),  // output wire [15 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(ena),      // input wire enb
  .web(wea),      // input wire [0 : 0] web
  .addrb(_addr2),  // input wire [18 : 0] addrb
  .dinb(dina2),    // input wire [15 : 0] dinb
  .doutb(doutb1)  // output wire [15 : 0] doutb
);

blockMemTopB blockTopB (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(_addr1),  // input wire [18 : 0] addra
  .dina(dinb1),    // input wire [15 : 0] dina
  .douta(_data_tomcub),  // output wire [15 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(ena),      // input wire enb
  .web(wea),      // input wire [0 : 0] web
  .addrb(_addr2),  // input wire [18 : 0] addrb
  .dinb(dinb2),    // input wire [15 : 0] dinb
  .doutb(doutb2)  // output wire [15 : 0] doutb
);
endmodule
























