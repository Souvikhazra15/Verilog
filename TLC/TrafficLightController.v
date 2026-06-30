module traffic_light_fsm( clock, light);
 input clk;
 output reg [0:2] light;

 parameter  s0=0, s1=1, s2=2;
 parameter red=3'b100, green=3'b010, yellow=3'b001;
 reg [0:1] state;

 always @(posedge clk) begin
    case (state)
       s0 : begin
        light <= green; state <= s1;
       end
       s1 : begin
        light <= yellow ; state <= s0;
       end
       s2 : begin
        light <= red; state <= s0;
       end
        default: begin
            light <= red;
            state <= s0
        end
    endcase
    
 end
endmodule
  