import 'dart:io';

import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiTypes.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/utils.dart';

class CreateFileExpression implements SundiExpression {
  @override
  String identifier = 'create file';

  @override
  String name = 'createfile_keyword';

  @override
  RegExp pattern = RegExp(
      r'(create\sfile\s"([a-zA-z.-_*0-9]+|[^a-z]+)"\sstored\sin\s{(\w+)})');

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    String vrName = Variable.getvrd(code.value);
    String fileName = SundiParser.getcstr(code.value);

    var vr = program.parser.getVar(vrName);
    if (vr != null) {
      File f = File(fileName);
      if (!await f.exists()) await f.create();
      // Cuando el archivo es creado se actualiza la variable conteniendo
      // la variable de tipo FILE
      await program.parser
          .update(vr, FileVariable(vrName, f, TYPE.FILE.IDENTIFIER));
    }
  }

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async =>
      setFileVariable(code, program, false);
}
