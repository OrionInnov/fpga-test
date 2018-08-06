////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description: Cascades four multipliers to implement one "long" multiply.
//
// Revision: N/A
// Additional Comments:
//
// TODO(fzliu): Use cascade I/Os of DSP48 blocks on Xilinx FPGAs.
//
////////////////////////////////////////////////////////////////////////////////

module math_mult_l #(

  // parameters

  parameter   DEVICE = "7SERIES",
  parameter   LATENCY = 4,

  // derived parameters

  localparam  WIDTH_A = (DEVICE == "7SERIES") ? 25 :
                        (DEVICE == "SPARTAN6") ? 18 :
                        (DEVICE == "VIRTEX5") ? 18 :
                        18;
  localparam  WIDTH_M = WIDTH_A + 18,
  localparam  MACC_LATENCY = LATENCY / 4,

  // bit width parameters

  localparam  WA = WIDTH_A - 1,
  localparam  W0 = WIDTH_M - 2,
  localparam  W1 = WIDTH_A + 51

) (

  // core interface

  input             clk,
  input             enb,
  input             rst,

  // data interface

  input   [ W0:0]   a,
  input   [ 34:0]   b,
  output  [ W1:0]   p

);

  // internal signals

  wire    [ 16:0]   ll_in_a;
  wire    [ 16:0]   ll_in_b;
  wire    [ 47:0]   ll_out;

  wire    [ 16:0]   lu_in_a;
  wire    [ 17:0]   lu_in_b;
  wire    [ 47:0]   lu_out;

  wire    [ WA:0]   ul_in_a;
  wire    [ 16:0]   ul_in_b;
  wire    [ 47:0]   ul_out;

  wire    [ WA:0]   uu_in_a;
  wire    [ 17:0]   uu_in_b;
  wire    [ 47:0]   uu_out;

  // lower-lower multiplier

  assign ll_in_a = a[16:0];
  assign ll_in_b = b[16:0];

  MACC_MACRO #(
    .DEVICE (DEVICE),
    .LATENCY (MACC_LATENCY),
    .WIDTH_A (WIDTH_A),
    .WIDTH_B (18),
    .WIDTH_P (18)
  ) mult_ll (
    .P (ll_out),
    .A ({1'b0, ll_in_a}),
    .ADDSUB (1'b1),
    .B ({1'b0, ll_in_b}),
    .CARRYIN (1'b0),
    .CE (enb),
    .CLK (clk),
    .LOAD (1'b1),
    .LOAD_DATA (48'b0),
    .RST (rst)
  );

  // lower-upper multiplier

  shift_reg #(
    .WIDTH (35),
    .DEPTH (MACC_LATENCY)
  ) shift_reg_math_mult_lu (
    .din ({a[16:0], b[34:17]}),
    .dout ({lu_in_a, lu_in_b})
  );

  MACC_MACRO #(
    .DEVICE (DEVICE),
    .LATENCY (MACC_LATENCY),
    .WIDTH_A (WIDTH_A),
    .WIDTH_B (18),
    .WIDTH_P (18)
  ) mult_ll (
    .P (lu_out),
    .A ({1'b0, lu_in_a}),
    .ADDSUB (1'b1),
    .B (lu_in_b),
    .CARRYIN (1'b0),
    .CE (enb),
    .CLK (clk),
    .LOAD (1'b1),
    .LOAD_DATA (ll_out >>> 17),
    .RST (rst)
  );

  // upper-lower multiplier

  shift_reg #(
    .WIDTH (WIDTH_A + 17),
    .DEPTH (MACC_LATENCY * 2)
  ) shift_reg_math_mult_ul (
    .din ({a[W0:17], b[16:0]}),
    .dout ({ul_in_a, ul_in_b})
  );

  MACC_MACRO #(
    .DEVICE (DEVICE),
    .LATENCY (MACC_LATENCY),
    .WIDTH_A (WIDTH_A),
    .WIDTH_B (25),
    .WIDTH_P (18)
  ) mult_ll (
    .P (ul_out),
    .A (ul_in_a),
    .ADDSUB (1'b1),
    .B ({1'b0, ul_in_b}),
    .CARRYIN (1'b0),
    .CE (enb),
    .CLK (clk),
    .LOAD (1'b1),
    .LOAD_DATA (lu_out),
    .RST (rst)
  );

  // upper-upper multiplier

  shift_reg #(
    .WIDTH (WIDTH_A + 18),
    .DEPTH (MACC_LATENCY * 3)
  ) shift_reg_math_mult_ul (
    .din ({a[W0:17], b[34:17]}),
    .dout ({uu_in_a, uu_in_b})
  );

  MACC_MACRO #(
    .DEVICE (DEVICE),
    .LATENCY (LATENCY / 4),
    .WIDTH_A (WIDTH_A),
    .WIDTH_B (18),
    .WIDTH_P (18)
  ) mult_ll (
    .P (uu_out),
    .A (uu_in_a),
    .ADDSUB (1'b1),
    .B (uu_in_b),
    .CARRYIN (1'b0),
    .CE (enb),
    .CLK (clk),
    .LOAD (1'b1),
    .LOAD_DATA (ul_out >> 18),
    .RST (rst)
  );

  // output product

  shift_reg #(
    .WIDTH (16),
    .DEPTH (MACC_LATENCY * 3)
  ) shift_reg_math_mult_out_0 (
    .clk (clk),
    .rst (rst),
    .din (ll_out),
    .dout (p[16:0])
  );

  shift_reg #(
    .WIDTH (16),
    .DEPTH (MACC_LATENCY)
  ) shift_reg_math_mult_out_1 (
    .clk (clk),
    .rst (rst),
    .din (ul_out),
    .dout (p[16:0])
  );

  assign p[W1:]

endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
