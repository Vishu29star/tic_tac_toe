import 'package:hive/hive.dart';
part 'game_result.g.dart';
@HiveType(typeId: 0)
class GameResult extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String result;
}