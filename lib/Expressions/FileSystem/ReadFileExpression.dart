import 'dart:io';

import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiTypes.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/utils.dart' show setFileVariable;

class ReadFileExpression implements SundiExpression {
  @override
  String identifier = 'read file';

  @override
  String name = "readfile_keyword";

  @override
  RegExp pattern = RegExp(
      r'(read\sfile\s"([a-zA-z.-_*0-9]+|[^a-z]+)"\sstored\sin\s{(\w+)})');

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async =>
      setFileVariable(code, program);

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    String vrName = code.instances[0].name;
    String fileName = SundiParser.getcstr(code.value);

    var vr = program.parser.getVar(vrName);
    if (vr != null && vr is FileVariable) {
      File f = File(fileName);
      await program.parser
          .update(vr, FileVariable(vrName, f, TYPE.FILE.IDENTIFIER));
    }
  }
}
