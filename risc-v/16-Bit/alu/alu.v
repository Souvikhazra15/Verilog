`timescale 1ns / 1ps

module alu (
    input  [15:0] A,
    input  [15:0] B,
    input  [3:0]  ALU_Control,

    output reg [15:0] Result,
    output Zero,
    output Carry,
    output Overflow
);

reg carry_temp;
reg overflow_temp;

always @(*) begin
    carry_temp    = 0;
    overflow_temp = 0;

    case (ALU_Control)

        // ADD
        4'b0000: begin
            {carry_temp, Result} = A + B;
            overflow_temp = (A[15] == B[15]) && (Result[15] != A[15]);
        end

        // SUB
        4'b0001: begin
            {carry_temp, Result} = A - B;
            overflow_temp = (A[15] != B[15]) && (Result[15] != A[15]);
        end

        // AND
        4'b0010:
            Result = A & B;

        // OR
        4'b0011:
            Result = A | B;

        // XOR
        4'b0100:
            Result = A ^ B;

        // Shift Left Logical
        4'b0101:
            Result = A << B[3:0];

        // Shift Right Logical
        4'b0110:
            Result = A >> B[3:0];

        // Set Less Than (Signed)
        4'b0111:
            Result = ($signed(A) < $signed(B)) ? 16'd1 : 16'd0;

        // Pass A
        4'b1000:
            Result = A;

        // Pass B
        4'b1001:
            Result = B;

        default:
            Result = 16'd0;

    endcase
end

assign Zero     = (Result == 16'd0);
assign Carry    = carry_temp;
assign Overflow = overflow_temp;

endmodule
