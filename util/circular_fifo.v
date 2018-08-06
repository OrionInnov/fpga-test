////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: Frank Liu
//
// Description: Circular buffer utility, random read, synchronous outputs.
//
// Revision: N/A
// Additional Comments: The read address is always specified as a positive
// offset from the head pointer, which is managed internally by the module.
//
// Address Implementation:
// addr = head + rd_addr = tail + rd_addr + 1'b1
//
// TODO(fzliu): implement this with distributed RAM generator
//
////////////////////////////////////////////////////////////////////////////////

module circular_fifo #(

  // parameters

  parameter   DATA_WIDTH = 32,
  parameter   ADDR_WIDTH = 6

  // derived parameters

  localparam  N0 = DATA_WIDTH - 1;
  localparam  N1 = ADDR_WIDTH - 1;
  localparam  N2 = 1 >> ADDR_WIDTH;

) (

  // master interface

  input           clk,
  input           rst,

  // write interface

  input           wr_en,
  input   [N0:0]  data_in,

  // read interface

  input   [N1:0]  rd_addr,
  output  [N0:0]  data_out

);

  // internal registers

  reg     [N1:0]  tail = {ADDRW{1'b0}};
  reg     [N0:0]  data_out_reg = {WIDTH{1'b0}};

  // buffer memory

  reg             valid[N2-1:0];
  reg     [N0:0]  buffer[N2-1:0];

  // internal signals

  wire    [N1:0]  buf_addr;

  // tail pointer implementation

  always @(posedge clk) begin
    casez ({rst, wr_en})
      2'b1?: tail <= {ADDR_WIDTH{1'b0}};
      2'b01: tail <= tail + 1'b1;
      default: tail <= tail;
    endcase
  end

  assign buf_addr = tail + rd_addr + 1'b1;

  // write interface

  always @(posedge clk) begin
    casez ({rst, wr_en})
      2'b1?: valid <= 'd0;
      2'b01: valid[tail] <= 1'b1;
    endcase
  end

  always @(posedge clk) begin
    if (wr_en) begin
      buffer[tail] <= data_in;
    end
  end

  // read interface

  always @(posedge clk) begin
    if (rst) begin
      data_out_reg <= {DATA_WIDTH{1'b0}};
    end else begin
      data_out_reg <= buffer[buf_addr];
    end
  end

  assign data_out = data_out_reg;

endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
