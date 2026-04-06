import 'package:isar/isar.dart';

part 'history_record.g.dart';

@collection
class HistoryRecord {
  Id id = Isar.autoIncrement;

  late String recognizedText;

  String? audioPath;

  @Index()
  late DateTime createdAt;

  @Index()
  DateTime? expiresAt;

  bool isFavorite = false;

  double? confidence;

  List<String> alternatives = [];
}
