////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description: Shift register utility.
//
// Revision: N/A
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module shift_reg #(

  // parameters

  parameter WIDTH = 1,
  parameter NUM_REGS = 10

) (

  // master interface

  input                 clk,
  input                 rst,

  // data interface

  input   [WIDTH-1:0]   data_in,
  output  [WIDTH-1:0]   data_out

);

  // internal registers

  reg     [WIDTH-1:0]   shift[NUM_REGS-1:0] = 'b0;

  // assign outputs

  always @(posedge clk) begin
    if (rst) begin
      shift <= 'd0;
    end else begin
      shift <= {shift[NUM_REGS-2:0], data_in};
    end
  end

  assign data_out = shift[NUM_REGS-1];

endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
