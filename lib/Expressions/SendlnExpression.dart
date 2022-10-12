import 'package:sundilang/Expressions/base/SundiExpression.dart'
    show SundiExpression;
import 'package:sundilang/SundiParser.dart' show SundiContentCode, SundiProgram;

class SendlnExpression implements SundiExpression {
  @override
  String name = "sendln_keyword";

  @override
  String identifier = "sendln";

  @override
  RegExp pattern = RegExp(r'(sendln\s("(.*)"|([0-9.]+)|({\w+})))$');
  // sendln [string|number]
  SendlnExpression();

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async =>
      program.send(code);

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async {
    // TODO: implement preload
  }
}
