module vending_machine(
    input clk,
    input rst,
    input [1:0] in,          // 00 = No Coin, 01 = Rs5, 10 = Rs10
    output reg out,
    output reg [1:0] change
);

parameter S0  = 2'b00;
parameter S5  = 2'b01;
parameter S10 = 2'b10;

reg [1:0] current_state, next_state;

always @(posedge clk or posedge rst) begin
    if(rst)
        current_state <= S0;
    else
        current_state <= next_state;
end

always @(*) begin

    next_state = current_state;

    case(current_state)

        S0: begin
            case(in)
                2'b00: next_state = S0;
                2'b01: next_state = S5;
                2'b10: next_state = S10;
                default: next_state = S0;
            endcase
        end

        S5: begin
            case(in)
                2'b00: next_state = S0;
                2'b01: next_state = S10;
                2'b10: next_state = S0;
                default: next_state = S5;
            endcase
        end

        S10: begin
            case(in)
                2'b00: next_state = S0;
                2'b01: next_state = S0;
                2'b10: next_state = S0;
                default: next_state = S10;
            endcase
        end

        default:
            next_state = S0;

    endcase

end

always @(*) begin

    out = 1'b0;
    change = 2'b00;

    case(current_state)

        S0: begin
            out = 0;
            change = 2'b00;
        end

        S5: begin
            if(in == 2'b00)
                change = 2'b01;
        end

        S10: begin
            if(in == 2'b00)
                change = 2'b10;

            else if(in == 2'b01) begin
                out = 1'b1;
                change = 2'b00;
            end

            else if(in == 2'b10) begin
                out = 1'b1;
                change = 2'b01;
            end
        end

    endcase

end

endmodule