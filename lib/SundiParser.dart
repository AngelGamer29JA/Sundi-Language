import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiTypes.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/SundiTokens.dart';
import 'package:sundilang/utils.dart';

extension IterableModifier<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) =>
      cast<E?>().firstWhere((v) => v != null && test(v), orElse: () => null);
}

class SundiParser {
  late SundiProgram programMain;
  Set<SundiError> errors = {};
  SundiParser(SundiProgram program) {
    programMain = program;
  }
  void registerVariable(Variable variable) {
    programMain.variables.add(variable);
  }

  void registerMainCode(SundiContentCode code) {
    programMain.code.add(code);
  }

  void addError(SundiError err) {
    errors.add(err);
  }

  Variable? getVar(String name) {
    var v = programMain.variables.firstWhereOrNull((vr) => vr.name == name);
    return v;
  }

  Future<bool> update<T>(Variable vrlast, dynamic variable) {
    var cm = Completer<bool>();
    bool removed = programMain.variables.remove(vrlast);
    if (removed) cm.complete(programMain.variables.add(variable));
    return cm.future;
  }

  static String ident(String str) {
    for (var idnt in sundiTokens) {
      var g =
          idnt.identifier.replaceAll('[string]', TYPE.STRING.PATTERN.pattern);
      var h = RegExp(g);
      if (str.startsWith(idnt.identifier) || h.hasMatch(str) == true) {
        return idnt.identifier;
      }
    }
    return '';
  }

  static String question(String str) {
    stdout.write(str);
    var line = stdin.readLineSync() ?? '';
    return line;
  }

  static String replace(String str, String content) {
    var rtr = str.replaceAll('(?<={)$str(?=})', content);
    return str;
  }

  static bool isToken(String token) {
    var t = sundiTokens.firstWhereOrNull((elm) => elm.identifier == token);
    if (t == null) return false;
    return true;
  }

  static SundiExpression getToken(String token) {
    SundiExpression t =
        sundiTokens.firstWhere((elm) => elm.identifier == token);
    return t;
  }

  /// Ignorar un comentario de la linea especificada
  static String ignoreComment(String str) {
    var ndt = str.replaceAllMapped(RegExp(r'(#.*|\/\/.*)'), (match) {
      return '';
    });
    return ndt;
  }

  /// Obtener el contenido de una variable
  static String getcstr(String str) {
    var strExp =
        RegExp(r'''(?<=").*(?=")|(?<=').*(?=')|([0-9.]+)|(undefined|null)''');
    var value = strExp.firstMatch(str);

    if (value != null) return value[0] as String;
    return '';
  }

  static String getNumber(String str) {
    String numReturn = TYPE.NUMBER.PATTERN.firstMatch(str)![0]!;
    return numReturn;
  }

  static String getString(String str) {
    String stringReturn = TYPE.STRING.PATTERN.firstMatch(str)![0]!;
    return stringReturn;
  }

  static bool vrinst(String str) {
    bool instance = TYPE.VARIABLE_INSTANCE.PATTERN.hasMatch(str);
    return instance;
  }

  static List<SundiVariableInstance> getvrInstances(
      String str, SundiParser parser, int line, File file) {
    var matches = RegExp(r'(?<={)\w+(?=})').allMatches(str);
    List<SundiVariableInstance> rtdAllMatches = [];
    for (var m in matches) {
      var value = m.group(0) ?? '';
      var varInst = SundiParser.vrinst(str);
      if (varInst && value != '') {
        String vrn = value;
        Variable? vr = parser.getVar(vrn);

        debugPrint('Add $vrn to instances at line $line');
        rtdAllMatches.add(SundiVariableInstance(vrn, m, m.start, m.end));

        int countIndex = str.indexOf('{$vrn}');
        if (vr == null) {
          parser.addError(SundiError(
              token:
                  '>> $line : $str\n   ${' ' * countIndex}${'^' * (vrn.length + 2)}\n   La variable {$vrn} no se ha definido.\n   El error se encuentra en la linea $line sobre la posicion $countIndex',
              error: Error.ERR_VARIABLE_NOT_DEFINED,
              position: countIndex,
              line: line,
              path: file.absolute.path));
        }
      }
    }
    return rtdAllMatches;
  }

  static String formatText(String str) {
    var symbols = {'\\n': '\n', '\\t': '\t'};
    var regex = RegExp(r'\\n|\\t');
    String c = str.replaceAllMapped(regex, (m) => symbols[m[0]]!);
    c = Color.parse(c);
    return c;
  }

  static RegExp get IDENTIFIER {
    return RegExp(r'[a-zA-z]+');
  }
}

class SundiVariableInstance {
  String name = '';
  String input = '';
  int start = 0;
  int end = 0;
  late RegExpMatch match;
  SundiVariableInstance(String name, RegExpMatch match, int start, int end) {
    this.name = name;
    this.match = match;
    this.start = start;
    this.end = end;
  }
}

class SundiContentCode {
  String file = '';
  String dirname = '';
  String token = '';
  String value = '';
  String path = '';
  SundiExpression code;
  int line = 0;
  int position = 0;
  List<SundiVariableInstance> instances = [];
  SundiContentCode(
      {this.file = '',
      this.path = '',
      this.dirname = '',
      this.token = '',
      required this.code,
      this.value = '',
      this.line = 0,
      this.position = 0,
      this.instances = const []});
}

class SundiProgram {
  List<SundiError> errors = [];
  Set<Variable> variables = {};
  List<SundiContentCode> code = [];
  late SundiParser parser;
  SundiProgram();

  void send(SundiContentCode code, [bool formatted = true]) {
    String content = SundiParser.getcstr(code.value);
    content = SundiParser.formatText((content == ''
        ? code.value.substring(code.code.identifier.length + 1)
        : content));
    bool vrInst = SundiParser.vrinst(content);
    if (vrInst) {
      String vrn = Variable.getvrd(content);
      Variable? vr = parser.getVar(vrn);
      if (vr != null) {
        content = content.replaceAll(RegExp(r'{\w+}'),
            (vr is FileVariable ? '[Type: File]' : vr.content));
      }
    }
    if (formatted) {
      print(content);
    } else if (!formatted) {
      stdout.write(content);
    }
  }
}

/*
  Ha ocurrido un error:
    <error_message>
  
    Type -> <error_type>
    Path: <path file>
  
  Error en popo.sdi:3 B1
    <error_message> B2
    
    Type -> <error_type> B3
    En: B4
      B5
      
  '''Ha ocurrido un error:
     <error_message>

    Type -> <error_type>
    Path: 
      <path_file>
  '''
*/
enum ErrorTyp { NULL }

class SundiError {
  late ErrorType error;
  String token = '';
  String path = '';
  int position = 0;
  int line = 0;
  SundiError(
      {error,
      this.token = '',
      this.path = '',
      this.position = 0,
      this.line = 0}) {
    this.error = error != null ? error : ErrorType(0, '', '');
  }
  void show() {
    print(Color.parse(
        "&4Error en ${p.basename(path)}:&f\n   $token\n   ${error.message}")); // B1
    print(Color.parse("   &4Type -> &f${error.TYPE}")); // B3
    stdout
        .write(Color.parse("   &4En:\n    &f$path:$line:$position\n\n")); // B5
  }
}
