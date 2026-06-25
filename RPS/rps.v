// Code your design here
module rock_paper_scissors( 
  input [3:0] player_1, 
  input  [3:0] player_2,
  output reg [1:0] winner
);

  //00 - draw
  //01 - player_1 wins
  //10 - player_2 wins
  //11 - invalid move
  
  always @(*) begin
    if (player_1 == 2'b11 && player_2 == 2'b11)
      winner =2'b11;
    else if (player_1 == player_2)
      winner = 2'b00;
      
    else begin
      case(player_1)
        
        // Rock
            2'b00:
            begin
              if(player_2 == 2'b10)
                    winner = 2'b01;
                else
                    winner = 2'b10;
            end
        
        // Paper
            2'b01:
            begin
              if(player_2 == 2'b00)
                    winner = 2'b01;
                else
                    winner = 2'b10;
            end

        // Scissors
            2'b10:
            begin
              if(player_2 == 2'b01)
                    winner = 2'b01;
                else
                    winner = 2'b10;
            end

            default:
                winner = 2'b11;
      endcase
    end
  end
endmodule
    
    