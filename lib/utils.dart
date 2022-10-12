// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:sundilang/Expressions/base/SundiTypes.dart' show TYPE;
import 'package:sundilang/SundiEnviroment.dart';
import 'package:sundilang/SundiParser.dart'
    show SundiContentCode, SundiError, SundiParser, SundiProgram;
import 'Expressions/base/SundiVariables.dart' show FileVariable;

abstract class Error {
  static ErrorType ERR_FILE_IS_DIR = ErrorType(0x200003, 'ERR_FILE_IS_DIR',
      'El archivo que se ha seleccionado es un directorio.');
  static ErrorType ERR_FILE_NOT_DEFINED =
      ErrorType(0x200001, 'ERR_FILE_NOT_DEFINED', '');
  static ErrorType ERR_FILE_EXT = ErrorType(0x200002, 'ERR_FILE_EXT',
      'La extensión del archivo seleccionado es incorrecta.');
  static ErrorType ERR_FILE_NOT_EXIST =
      ErrorType(0x200000, 'ERR_FILE_NOT_EXIST', '');
  static ErrorType ERR_NOT_EXIST_SELECTED = ErrorType(0x200005,
      'ERR_NOT_EXIST_SELECTED', 'El archivo que se ha seleccionado no existe.');
  static ErrorType ERR_VARIABLE_NOT_DEFINED =
      ErrorType(0x300000, 'ERR_VARIABLE_NOT_DEFINED', '');
  static ErrorType ERR_VARIABLE_DEFINITION =
      ErrorType(0x300001, 'ERR_VARIABLE_DEFINITION', '');
  static ErrorType ERR_INVALID_TOKEN =
      ErrorType(0x300002, 'ERR_INVALID_TOKEN', '');
  static ErrorType ERR_SYNTAX_ERROR =
      ErrorType(0x300003, 'ERR_SYNTAX_ERROR', 'La sintaxis no es correcta');
  static ErrorType ERR_NO_ARGUMENTS = ErrorType(
      0x20004, 'ERR_NO_ARGUMENTS', 'No se ha establecido ningun parámetro');
  static ErrorType ERR_NOT_FILETYPE =
      ErrorType(0x300004, 'ERR_NOT_FILETYPE', '');
}

class ErrorType {
  int _CODE = 0;
  String _TYPE = '';
  String message = '';
  ErrorType(int code, String typename, String msg) {
    _CODE = code;
    _TYPE = typename;
    message = msg;
  }
  int get CODE {
    return _CODE;
  }

  String get TYPE {
    return _TYPE;
  }
}

void debugPrint(String str) {
  bool debug = Enviroment.debug;
  if (debug) print("[DEBUG] $str"); // if true send this message for debug
}

/// Imprimir en terminal un error de manera sencilla
void errorPrint(String str, [String type = '']) {
  print('Se he presentado un error');
  print('Error: $str');
  if (type != '') print('Type: $type');
}

void checkFileContainer(SundiContentCode code, SundiProgram program) {
  /*
      Identificar si la variable de tipo File contiene
      o un archivo o es nula, de lo contrario arrojara un error
      
      ERR_NOT_FILETYPE
    */

  String variableName = code.instances[0].name;
  var vr = program.parser.getVar(variableName);
  bool isfile = vr is FileVariable;

  int countIndex = '>> ${code.line}: ${code.value}'.indexOf('{$variableName}');
  String errorValue =
      '>> ${code.line}: ${code.value}\n   ${' ' * countIndex}${'^' * (variableName.length + 2)}';
  if (vr != null && !isfile) {
    program.parser.addError(SundiError(
        token:
            '$errorValue\n   La variable $variableName no contiene ningun tipo de archivo\n   puedes leerla o crear primero un archivo antes usarla\n   para escribir o interactuar con la variable.',
        error: Error.ERR_NOT_FILETYPE,
        position: countIndex,
        line: code.line,
        path: code.path));
  }
}

void setFileVariable(SundiContentCode code, SundiProgram program,
    [bool checkfile = true]) async {
  /*

      Atribuir el valor de tipo File a la variable
      Estando vacio sin ningun archivo cargado.

      Cuando se compruebe si hay un archivo en la variable, en caso de haber
      el script se ejecutara, de lo contrario dara un error ERR_NOTFILE_TYPE
    
    */
  String filename = SundiParser.getcstr(code.value);
  int countIndex = '>> ${code.line}: ${code.value}'.indexOf(filename);
  String errval =
      '>> ${code.line}: ${code.value}\n   ${' ' * countIndex}${'^' * (filename.length)}';
  if (!await File(filename).exists() && checkfile == true) {
    program.parser.addError(SundiError(
        error: Error.ERR_FILE_NOT_EXIST,
        token:
            '$errval\n   No se encontro ningun archivo con el nombre $filename\n   Verifica el nombre de tu archivo, o si tu archivo existe',
        position: countIndex,
        line: code.line,
        path: code.path));
  }
  String vrname = code.instances[0].name;
  var vr = program.parser.getVar(vrname);
  if (vr != null) {
    FileVariable fvr = FileVariable(vr.name, null, TYPE.FILE.IDENTIFIER);
    await program.parser.update(vr, fvr);
  }
}

void checkFileExist(SundiContentCode code, SundiProgram program) async {
  String filename = SundiParser.getcstr(code.value);
  int countIndex = '>> ${code.line}: ${code.value}'.indexOf(filename);
  String errval =
      '>> ${code.line}: ${code.value}\n   ${' ' * countIndex}${'^' * (filename.length)}';
  if (!await File(filename).exists()) {
    program.parser.addError(SundiError(
        error: Error.ERR_FILE_NOT_EXIST,
        token:
            '$errval\n   No se encontro ningun archivo con el nombre $filename\n   Verifica el nombre de tu archivo, o si tu archivo existe',
        position: countIndex,
        line: code.line,
        path: code.path));
  }
}

class Color {
  static Map<String, Map<String, String>> colors = {
    "0": {"name": 'black', "value": '\x1B[30m'},
    "1": {"name": 'dark_blue', "value": '\x1B[34m'},
    "2": {"name": 'dark_green', "value": '\x1B[32m'},
    "3": {"name": 'dark_aqua', "value": '\x1B[36m'},
    "4": {"name": 'dark_red', "value": '\x1B[31m'},
    "5": {"name": 'dark_purple', "value": '\x1B[35m'},
    "6": {"name": 'gold', "value": '\x1B[33m'},
    "7": {"name": 'gray', "value": '\x1B[37m'},
    "8": {"name": 'dark_gray', "value": '\x1B[90m'},
    "9": {"name": 'blue', "value": '\x1B[94m'},
    "a": {"name": 'green', "value": '\x1B[92m'},
    "b": {"name": 'aqua', "value": '\x1B[96m'},
    "c": {"name": 'red', "value": '\x1B[91m'},
    "d": {"name": 'light_purple', "value": '\x1B[95m'},
    "e": {"name": 'yellow', "value": '\x1B[93m'},
    "f": {"name": 'white', "value": '\x1B[97m'}
  };

  static String parse(String str) {
    var regex = RegExp(r'&([0-9a-fr])');
    var colors = Color.colors;
    bool old = Platform.operatingSystemVersion
        .contains(RegExp('Windows 8|Windows 8.1|Windows 7'));
    var c = str.replaceAllMapped(
        regex, (m) => (old ? '' : colors[m[1]]!["value"]!));
    if (old) return c;
    return '$c\x1B[0m';
  }

  static String getName(String str) {
    String d = Color.colors.containsKey(str) ? Color.colors[str]!['name']! : '';
    return d;
  }
}
