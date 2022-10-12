import 'dart:io';

import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/utils.dart' show checkFileContainer;

class WriteFileExpression implements SundiExpression {
  @override
  String identifier = 'write [string] to file';

  @override
  String name = 'writefile_keyword';

  @override
  RegExp pattern =
      RegExp(r'(write\s"([a-zA-z.-_*0-9]|[^a-z])+"\sto\sfile\sin\s{(\w+)})');
  // write "hola" to file in {file}
  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    var fvar = program.parser.getVar(code.instances[0].name);
    String content = SundiParser.getcstr(code.value);

    if (fvar != null && fvar.content is File) {
      fvar as FileVariable;
      await fvar.write(content);
    }
  }

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async =>
      checkFileContainer(code, program);
}
