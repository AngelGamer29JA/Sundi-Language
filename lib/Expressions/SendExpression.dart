import 'dart:io';

import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiParser.dart';

class SendExpression implements SundiExpression {
  @override
  String name = "send_keyword";

  @override
  String identifier = "send";

  @override
  RegExp pattern = RegExp(r'(send\s("(.*)"|([0-9.]+)|({\w+})))$');
  SendExpression();

  @override
  Future<void> runner(SundiContentCode code, SundiProgram program) async =>
      program.send(code, false);

  @override
  Future<void> preload(SundiContentCode code, SundiProgram program) async {
    // TODO: implement preload
  }
}
