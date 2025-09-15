// Converted to Verilog-2001 (no SV features)
// default_nettype of none prevents implicit wire declaration.
`default_nettype none

module counter #(
  parameter C_WIDTH  = 4,
  parameter MAX_COUNT  = {C_WIDTH{1'b1}},
  parameter C_INIT = {C_WIDTH{1'b0}}
)(
  input  wire               clk,
  input  wire               clken,
  input  wire               rst,
  input  wire               load,
  input  wire               incr,
  input  wire               decr,
  input  wire [C_WIDTH-1:0] load_value,
  output wire [C_WIDTH-1:0] count,
  output wire               is_zero
);

/////////////////////////////////////////////////////////////////////////////
// Local Parameters
/////////////////////////////////////////////////////////////////////////////
localparam [C_WIDTH-1:0] LP_ZERO = {C_WIDTH{1'b0}};
localparam [C_WIDTH-1:0] LP_ONE  = {{C_WIDTH-1{1'b0}},1'b1};
localparam [C_WIDTH-1:0] LP_MAX  = MAX_COUNT;

/////////////////////////////////////////////////////////////////////////////
// Registers
/////////////////////////////////////////////////////////////////////////////
reg [C_WIDTH-1:0] count_r;
reg               is_zero_r;

/////////////////////////////////////////////////////////////////////////////
// Begin RTL
/////////////////////////////////////////////////////////////////////////////
assign count   = count_r;
assign is_zero = is_zero_r;

always @(posedge clk) begin
  if (rst) begin
    count_r <= C_INIT;
  end else if (clken) begin
    if (load) begin
      count_r <= load_value;
    end else if (incr & ~decr) begin
      if (count_r == LP_MAX)
        count_r <= LP_ZERO;
      else
        count_r <= count_r + 1'b1;
    end else if (~incr & decr) begin
      if (count_r == LP_ZERO)
        count_r <= LP_MAX;
      else
        count_r <= count_r - 1'b1;
    end else begin
      count_r <= count_r; // hold
    end
  end
end

always @(posedge clk) begin
  if (rst) begin
    is_zero_r <= (C_INIT == LP_ZERO);
  end else if (clken) begin
    if (load) begin
      is_zero_r <= (load_value == LP_ZERO);
    end else begin
      // Update only when exactly one of incr/decr is asserted
      if (incr ^ decr) begin
        is_zero_r <= (decr && (count_r == LP_ONE)) ||
                     (incr && (count_r == LP_MAX));
      end else begin
        is_zero_r <= is_zero_r; // hold
      end
    end
  end else begin
    is_zero_r <= is_zero_r; // hold
  end
end

endmodule
`default_nettype wire
