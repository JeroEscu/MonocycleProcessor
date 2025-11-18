module program_counter (
  input clk,
  input rst_n,
  input PCSrc,             
  input [31:0] pc_target,   // Dirección de salto (resultado ALU)
  output [31:0] pc_out,
  output [31:0] pc_plus_4   // PC+4 para tipo J
);
  reg [31:0] pc_reg;
  wire [31:0] next_pc_reg;
  wire [31:0] pc_plus_4_internal;
  
  // Sumador para PC + 4
  sum_unit sum_inst(
    .A(pc_reg),
    .B(32'd4),
    .S(pc_plus_4_internal)
  );
  
  assign pc_plus_4 = pc_plus_4_internal; // ← EXPORTAR PC+4
  
  // Multiplexor
  assign next_pc_reg = PCSrc ? pc_target : pc_plus_4_internal;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      pc_reg <= 32'b0;
    else
      pc_reg <= next_pc_reg;
  end
  
  assign pc_out = pc_reg;
  
endmodule