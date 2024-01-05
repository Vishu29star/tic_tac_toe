import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tic_tac_toe/src/game_result.dart';

class GameResultListScreen extends StatelessWidget {
  final box;
  const GameResultListScreen(this.box, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: getMyObjects(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final myObjects = snapshot.data?.reversed.toList();
            if(myObjects ==  null){
              return const Center(child: Text('something wrong'));
            }
            if(myObjects.length < 1){
              return const Center(child: Text('No data'));
            }
            return ListView.builder(
              itemCount: myObjects.length,
              itemBuilder: (context, index) {

                return ListTile(
                  title: Text(myObjects[index].name),
                  subtitle: Text(myObjects[index].result),
                  // Add more widget properties based on your MyObject class
                );
              },
            );
          }
        },
      ),
    );
  }


  Future<List<GameResult>> getMyObjects() async {
    final box = Hive.box<GameResult>('gameResult');
    return box.values.toList();
  }
}
