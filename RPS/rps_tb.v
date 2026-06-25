`timescale 1ns/1ps

module tb;

  reg [1:0] player_1;
  reg [1:0] player_2;

wire [1:0] winner;

rock_paper_scissors uut(
  .player_1(player_1),
  .player_2(player_2),
    .winner(winner)
);

task display_result;
begin
  $display("0=rock, 1=paper, 2=scissors");
  $display("---------------------------------------");
  $display("Player1 = %0d",player_1);
  $display("Player2 = %0d",player_2);

    case(winner)

        2'b00:
            $display("Result : Draw");

        2'b01:
            $display("Result : Player 1 Wins");

        2'b10:
            $display("Result : Player 2 Wins");

        2'b11:
            $display("Result : Invalid Move");

    endcase

end
endtask

initial begin

// Rock vs Rock
player_1 = 2'b00;
player_2 = 2'b00;
#10;
display_result();

// Rock vs Paper
player_1 = 2'b00;
player_2 = 2'b01;
#10;
display_result();

// Rock vs Scissors
player_1 = 2'b00;
player_2 = 2'b10;
#10;
display_result();

// Paper vs Rock
player_1 = 2'b01;
player_2 = 2'b00;
#10;
display_result();

// Paper vs Paper
player_1 = 2'b01;
player_2 = 2'b01;
#10;
display_result();

// Paper vs Scissors
player_1 = 2'b01;
player_2 = 2'b10;
#10;
display_result();

// Scissors vs Rock
player_1 = 2'b10;
player_2 = 2'b00;
#10;
display_result();

// Scissors vs Paper
player_1 = 2'b10;
player_2 = 2'b01;
#10;
display_result();

// Scissors vs Scissors
player_1 = 2'b10;
player_2 = 2'b10;
#10;
display_result();

// Invalid Input
player_1 = 2'b11;
player_2 = 2'b00;
#10;
display_result();

$finish;

end

endmodule