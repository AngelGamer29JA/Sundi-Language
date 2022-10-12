import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sundilang/SundiGlobal.dart';
import 'package:sundilang/SundiParser.dart' show SundiProgram;

import 'package:sundilang/SundiInstance.dart';
import 'package:sundilang/utils.dart';

class SundiCore {
  late File file;
  late SundiProgram program;
  SundiCore(File fl) {
    file = fl;
  }

  Future<void> runInstance() async {
    var main = SundiProgram();
    var instance = SundiInstance(main, file);

    program = main;
    program.variables = globalVariables;
    await instance.runParser();
    instance.run();
  }

  static bool checkExt(String filename) {
    debugPrint('Extension file ${path.extension(filename)}');
    if (path.extension(filename) == '.sdi') return true;
    return false;
  }
}
