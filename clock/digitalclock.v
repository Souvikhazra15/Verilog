module digital_clock (
    input clk,
    input rst,
    output reg [5:0] secs,
    output reg [5:0] mins,
    output reg [4:0] hrs
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        secs <= 6'd0;
        mins <= 6'd0;
        hrs  <= 5'd0;
    end
    else begin
        if (secs == 6'd59) begin
            secs <= 6'd0;

            if (mins == 6'd59) begin
                mins <= 6'd0;

                if (hrs == 5'd23)
                    hrs <= 5'd0;
                else
                    hrs <= hrs + 1'b1;

            end
            else begin
                mins <= mins + 1'b1;
            end

        end
        else begin
            secs <= secs + 1'b1;
        end
    end
end

endmodule