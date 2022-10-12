/*
tokens.set('sendln', {
  name: 'sendln_keyword',
  pattern: /(sendln\s"([a-zA-z.-_*0-9]|[^a-z])+"$|([0-9.]+)$)/,
  runner: (ConsoleStringLN) => {
    console.log(ConsoleStringLN.toString());
  }
});

*/

import 'package:sundilang/SundiParser.dart';

class SundiExpression {
  late String name;
  late String identifier;
  late RegExp pattern;
  SundiExpression();

  Future<void> runner(SundiContentCode code, SundiProgram program) async {}
  Future<void> preload(SundiContentCode code, SundiProgram program) async {}
}
