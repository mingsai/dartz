import "package:test/test.dart";
import 'package:enumerators/combinators.dart' as c;
import 'package:dartz/dartz.dart';
import 'laws.dart';

void main() {
  final intLists = c.listsOf(c.ints);

  bool bonkersEquality(a, b) {
    if (a == b) {
      return true;
    } else if (a is List && b is List) {
      return ilist(a) == ilist(b);
    } else if (a is Option && b is Option) {
      return OptionM.map2(a, b, bonkersEquality) | false;
    } else if (a is Either && b is Either) {
      return EitherM.map2(a, b, bonkersEquality).getOrElse(false);
    } else {
      return false;
    }
  }

  group("ListM", () => checkMonadLaws(ListM, equality: bonkersEquality));

  group("ListTMonad+Id", () => checkMonadLaws(listTMonad(IdM), equality: bonkersEquality));

  group("ListTMonad+Either", () => checkMonadLaws(listTMonad(EitherM), equality: bonkersEquality));

  group("ListTr", () => checkTraversableLaws(ListTr, intLists, equality: bonkersEquality));

  group("ListM+Foldable", () => checkFoldableMonadLaws(ListFo, ListM, equality: bonkersEquality));

  group("ListMi", () => checkMonoidLaws(ListMi, intLists, equality: bonkersEquality));
}