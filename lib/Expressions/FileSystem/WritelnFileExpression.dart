import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/utils.dart' show checkFileContainer;

class WritelnFileExpression implements SundiExpression {
  @override
  String identifier = 'writeln [string] to file';

  @override
  String name = 'writelnfile_keyword';

  @override
  RegExp pattern =
      RegExp(r'(writeln\s"([a-zA-z.-_*0-9]|[^a-z])+"\sto\sfile\sin\s{(\w+)})');
  // writeln "hola" to file in {file}
  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    var fvar = program.parser.getVar(code.instances[0].name) as FileVariable;
    String content = SundiParser.getcstr(code.value);

    await fvar.writeln(content);
  }

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async =>
      checkFileContainer(code, program);
}
