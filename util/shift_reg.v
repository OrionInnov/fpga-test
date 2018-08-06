////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description: Parameterizable shift register utility.
//
// Revision: N/A
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module shift_reg #(

  // parameters

  parameter   WIDTH = 1,
  parameter   DEPTH = 10,

  // bit width parameters

  localparam  N0 = WIDTH - 1,
  localparam  N1 = DEPTH - 1

) (

  // master interface

  input             clk,
  input             rst,

  // data interface

  input   [ N0:0]   din,
  output  [ N0:0]   dout

);

  // register declaration

  reg     [ N0:0]   shift[N1:0];

  // shift register implementation

  genvar i;
  generate
  for (i = 0; i < DEPTH; i = i + 1) begin : shift_reg

    always @(posedge clk) begin
      if (rst) begin
        shift[i] <= {WIDTH{1'b0}};
      end else begin
        shift[i] <= (i == 0) ? data_in : shift[i-1];
      end
    end

  end
  endgenerate

  // assign output

  assign data_out = shift[N1];

endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
