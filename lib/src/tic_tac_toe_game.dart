import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tic_tac_toe/src/game_result.dart';

import 'game_results_screen.dart';

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));

  bool isPlayerOne = true;
  int moves = 0;
  Box? box;

  @override
  void initState() {
    // TODO: implement initState
    initHiveBox();
    super.initState();
  }
initHiveBox() async {
    box = await Hive.openBox<GameResult>('gameResult');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe Game'),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameResultListScreen(box)));
        }, icon: Icon(Icons.next_plan_outlined))],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Player ${isPlayerOne ? 'One' : 'Two'}\'s turn',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            buildGameBoard(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetGame();
              },
              child: Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGameBoard() {
    return Column(
      children: List.generate(
        3,
            (rowPos) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (colPos) => GestureDetector(
              onTap: () {
                if (board[rowPos][colPos].isEmpty) {
                  setState(() {
                    board[rowPos][colPos] = isPlayerOne ? 'X' : 'O';
                    isPlayerOne = !isPlayerOne;
                    moves++;
                    if (checkWinner(rowPos, colPos)) {
                      var gameResult = GameResult()
                      ..name = !isPlayerOne ? "Player one" : "Player Second"
                      ..result = "Win";
                      if(box != null){
                        box?.add(gameResult);
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Player ${isPlayerOne ? 'Two' : 'One'} Wins!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  resetGame();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (moves == 9) {
                      var gameResult = GameResult()
                        ..name = "Nobody"
                        ..result = "Draw";
                      if(box != null){
                        box?.add(gameResult);
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('It\'s a Draw!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  resetGame();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Text(
                    board[rowPos][colPos],
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkWinner(int rowPos, int colPos) {
    // Check row
    if (board[rowPos][0] == board[rowPos][1] && board[rowPos][1] == board[rowPos][2] && board[rowPos][0].isNotEmpty) {
      return true;
    }
    // Check column
    if (board[0][colPos] == board[1][colPos] && board[1][colPos] == board[2][colPos] && board[0][colPos].isNotEmpty) {
      return true;
    }
    // Check diagonals
    if ((board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0].isNotEmpty) ||
        (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2].isNotEmpty)) {
      return true;
    }
    return false;
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      isPlayerOne = true;
      moves = 0;
    });
  }

}