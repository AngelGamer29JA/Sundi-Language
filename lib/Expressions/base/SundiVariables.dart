import 'dart:convert';
import 'dart:io';

import 'package:sundilang/Expressions/base/SundiTypes.dart';

/*    name: varname,
    content: content,
    type: type(str)
* */
class Variable {
  late String name;
  dynamic content;
  late String type;

  Variable(String varName, dynamic varContent, String varType) {
    name = varName;
    content = varContent;
    type = varType;
  }

  /// Identificar una variable
  static bool isvar(str) {
    var rgxMatch = RegExp(r'^(\w+\s=\s)');
    if (!rgxMatch.hasMatch(str)) return false;
    return true;
  }

  /// Obtener el tipo de la variable
  static String? getType(String variable) {
    if (TYPE.STRING.PATTERN.hasMatch(variable)) return 'STRING';
    if (TYPE.NUMBER.PATTERN.hasMatch(variable)) return 'NUMBER';
    if (TYPE.BOOL.PATTERN.hasMatch(variable)) return 'BOOL';
    if (TYPE.NULL.PATTERN.hasMatch(variable)) return 'NULL';
    return null;
  }

  /// Obtener el nombre de una vairbale instanciada
  static String getvrd(String str) {
    RegExp varInstance = TYPE.VARIABLE_INSTANCE.PATTERN;
    if (str == '') return 'null';
    if (!varInstance.hasMatch(str)) return 'null';

    var match = varInstance.firstMatch(str)!;
    return match[0]!;
  }

  /// Obtener el nombre de una variable
  static String getvrn(String str) {
    var varRegex = RegExp(r'^(\w+)');
    return (varRegex.firstMatch(str)!)[0]!;
  }
}

class FileVariable extends Variable {
  @override
  String name = '';

  @override
  String type = '';

  @override
  dynamic content;

  late File? file;

  FileVariable(String varName, dynamic content, String varType)
      : super(varName, content, varType) {
    if (content is File) {
      file = content as File;
    } else {
      file = null;
    }
  }

  Future<String> getFileContent() async {
    File f = content as File;
    String rtrc = await f.readAsString(encoding: utf8);
    return rtrc;
  }

  Future<File> write(String str) async {
    return file!.writeAsString(str, mode: FileMode.append, encoding: utf8);
  }

  Future<File> writeln(String str) async {
    return file!.writeAsString('$str\n', mode: FileMode.append, encoding: utf8);
  }
}
