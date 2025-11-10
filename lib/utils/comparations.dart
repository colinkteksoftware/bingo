import 'package:bingo/core/data/models/bingo.dart';

bool listsEquals(List<Bingo> a, List<Bingo> b) {
  if (a.length != b.length) return false;
  
  List<Bingo> sortedA = List.from(a)..sort((x, y) => x.bingoId!.compareTo(y.bingoId!));
  List<Bingo> sortedB = List.from(b)..sort((x, y) => x.bingoId!.compareTo(y.bingoId!));

  for (int i = 0; i < sortedA.length; i++) {
    if (sortedA[i] != sortedB[i]) return false;
  }

  return true;
}
