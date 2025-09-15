// Vendor-agnostic simple dual-port RAM (common or independent clocks)
// Features used here:
// - Port A: write (wea)
// - Port B: read
// - READ_MODE_B: "read_first" (old data when read and write same address)
// - READ_LATENCY_B: >=1 (default 1)
// - Full-width write (no byte-enables)
module sdpram_temp #(
  parameter integer ADDR_WIDTH_A        = 8,
  parameter integer ADDR_WIDTH_B        = 8,
  parameter integer WRITE_DATA_WIDTH_A  = 64,
  parameter integer READ_DATA_WIDTH_B   = 64,
  parameter integer READ_LATENCY_B      = 1,  // 1 matches your XPM use
  // WRITE_MODE_B: 0="read_first" (supported), 1="write_first", 2="no_change"
  parameter integer WRITE_MODE_B        = 0
)(
  input  wire                          clka,
  input  wire                          clkb,
  input  wire                          ena,
  input  wire                          enb,
  input  wire [ADDR_WIDTH_A-1:0]       addra,
  input  wire [ADDR_WIDTH_B-1:0]       addrb,
  input  wire                          wea,
  input  wire [WRITE_DATA_WIDTH_A-1:0] dina,
  output reg  [READ_DATA_WIDTH_B-1:0]  doutb,
  input  wire                          regceb,
  input  wire                          rstb
);
  // Assumptions for this lightweight model:
  // - Same width on A and B (WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B).
  // - Same depth on A and B (ADDR_WIDTH_A == ADDR_WIDTH_B).
  // - READ_MODE_B "read_first" implemented when WRITE_MODE_B==0.

  localparam integer DEPTH = (1 << ADDR_WIDTH_A);

  reg [WRITE_DATA_WIDTH_A-1:0] mem [0:DEPTH-1];
  reg [READ_DATA_WIDTH_B-1:0]  rd_sample;
  reg [READ_DATA_WIDTH_B-1:0]  pipe [0:READ_LATENCY_B-1];

  integer i;

  // Port A: Write
  always @(posedge clka) begin
    if (ena && wea) begin
      mem[addra] <= dina;
    end
  end

  // Port B: Read (read_first semantics w.r.t. same-cycle write)
  // For common clock, order of sampling ensures "old" data is read.
  always @(posedge clkb) begin
    // sample current memory at addrb
    if (enb) begin
      rd_sample <= mem[addrb];
    end
    // pipeline/register the sampled data
    if (rstb) begin
      for (i = 0; i < READ_LATENCY_B; i = i + 1) begin
        pipe[i] <= {READ_DATA_WIDTH_B{1'b0}};
      end
      doutb <= {READ_DATA_WIDTH_B{1'b0}};
    end else begin
      // shift pipe
      if (enb && regceb) begin
        pipe[0] <= rd_sample;
      end
      for (i = 1; i < READ_LATENCY_B; i = i + 1) begin
        pipe[i] <= pipe[i-1];
      end
      if (regceb) begin
        doutb <= pipe[READ_LATENCY_B-1];
      end
    end
  end
endmodule
