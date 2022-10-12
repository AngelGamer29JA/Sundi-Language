import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';

class PromptExpression implements SundiExpression {
  @override
  String identifier = 'prompt';

  @override
  String name = 'prompt_keyword';

  @override
  RegExp pattern =
      RegExp(r'(prompt\s"([a-zA-z.-_*0-9]|[^a-z])+"\sstored\sin\s{(\w+)}$)');

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    String vrName = code.instances[0].name;
    String question = SundiParser.getcstr(code.instances[0].name);

    var d = program.parser.getVar(vrName);
    var _qst =
        SundiParser.question(question); // Llamando una interfaz de la pregunta
    if (d != null) d.content = _qst;
  }

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async {
    // TODO: implement preload
  }
}
