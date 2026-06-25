module alu_4bit(
    input [3:0] a, b,
    input [3:0] opcode,
    input enable,
    output reg [3:0] ALU_out,
    output reg zero,negative,carry,overflow
);

    reg [4:0] temp;
    parameter   ADD = 4'b0000,
                SUB = 4'b0001,
                INCA= 4'b0010,
                DECA= 4'b0011,
                AND = 4'b0100,
                OR  = 4'b0101,
                XOR = 4'b0110,
                NOT = 4'b0111,
                SLL = 4'b1000,
                SRL = 4'b1001,
                SRA = 4'b1010;

    always @(*) begin
        temp = 0;
        ALU_out = 0;
        carry = 0;
        zero = 0;
        negative = 0;
        if(enable) begin
            case(opcode)
                ADD: begin
                    temp = a + b;
                    ALU_out = temp[3:0];
                    carry = temp[4];
                    overflow = (a[3] == b[3]) && (ALU_out[3] != a[3]);
                end
                SUB: begin
                    temp = a - b;
                    ALU_out = temp[3:0];
                    carry = (a>=b);
                    overflow = (a[3] != b[3]) && (ALU_out[3] != a[3]);
                end
                INCA: begin
                    temp = a + 1; 
                    ALU_out = temp[3:0];
                    carry = temp[4];
                    overflow = (a == 4'b0111);
                end
                DECA: begin
                    temp = a - 1;
                    ALU_out = temp[3:0];
                    carry = (a >= 1);
                    overflow = (a == 4'b1000);
                end

                AND: ALU_out = a & b;
                OR: ALU_out = a | b;
                XOR: ALU_out = a ^ b;
                NOT: ALU_out = ~a;

                SLL: begin
                    ALU_out = a << 1;
                    carry = a[3];
                end
                SRL: begin
                    ALU_out = a >> 1;
                    carry = a[0];
                end
                SRA: begin
                    ALU_out = {a[3],a[3:1]};
                    carry = a[0];
                end            
                default: ALU_out = 4'b0000;
            endcase
        end
        zero = (ALU_out == 0);
        negative = ALU_out[3];
    end

endmodule