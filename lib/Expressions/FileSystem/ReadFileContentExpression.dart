import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/utils.dart' show checkFileContainer;

class ReadFileContentExpression implements SundiExpression {
  @override
  String identifier = 'read content';
  // template: read file [string] stored in [{type:File}]

  @override
  String name = 'readfilecontent_keyword';

  @override
  RegExp pattern = RegExp(r'(read\scontent\sin\s{(\w+)}\sto\s{(\w+)})');
  // read file content {file} to {content}

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    var file = program.parser.getVar(code.instances[0].name) as FileVariable;
    var toContent = program.parser.getVar(code.instances[1].name);

    if (toContent != null) {
      toContent.content = await file.getFileContent();
    }
  }

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async =>
      checkFileContainer(code, program);
}
