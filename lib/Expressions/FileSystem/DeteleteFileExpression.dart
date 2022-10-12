import 'dart:io';

import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/utils.dart';

class DeleteFileExpression implements SundiExpression {
  @override
  String identifier = "delete file";

  @override
  String name = "deletefile_keyword";

  @override
  RegExp pattern = RegExp(r'(delete\sfile\s"([a-zA-z.-_*0-9]+|[^a-z]+)")');

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async =>
      checkFileExist(code, program);

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async {
    String fileName = SundiParser.getcstr(code.value);
    File f = File(fileName);
    await f.delete();
  }
}
