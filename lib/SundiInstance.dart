import 'dart:convert';
import 'dart:io';

import 'package:sundilang/SundiParser.dart';
import 'package:sundilang/Expressions/base/SundiExpression.dart';
import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:sundilang/utils.dart';
import 'package:path/path.dart' as path;

class SundiInstance {
  late SundiProgram main;
  late File file;
  late List<String> fileContent;
  late SundiParser mainParser;

  /// Path of main file
  String filepath = '';
  SundiInstance(this.main, this.file) {
    filepath = file.absolute.path;

    mainParser = SundiParser(main);
    main.parser = mainParser;
  }

  Future<void> runParser() async {
    fileContent = await file.readAsLines(encoding: utf8);
    for (int line = 0; line < fileContent.length; line++) {
      String lvalue = SundiParser.ignoreComment(fileContent[line]);
      if (SundiParser.IDENTIFIER.hasMatch(lvalue)) {
        String ident = SundiParser.ident(lvalue);
        String tokenName = (SundiParser.IDENTIFIER.firstMatch(lvalue)!)[0]!;

        if (ident != '') tokenName = ident;
        // Identificar variables y guardarlas en el main code

        if (Variable.isvar(lvalue) && Variable.getType(lvalue) == null) {
          mainParser.addError(SundiError(
              token: lvalue,
              error: Error.ERR_VARIABLE_DEFINITION,
              position: lvalue.indexOf(tokenName),
              line: line,
              path: filepath));
        }
        if (!Variable.isvar(lvalue) && !SundiParser.isToken(tokenName)) {
          mainParser.addError(SundiError(
              token: lvalue,
              error: Error.ERR_INVALID_TOKEN,
              position: lvalue.indexOf(tokenName),
              line: line,
              path: filepath));
        }

        // Es una variable
        if (Variable.isvar(lvalue) && Variable.getType(lvalue) != null) {
          String variableType =
              Variable.getType(lvalue)!; // Tipo de la variable
          dynamic vrValue =
              SundiParser.getcstr(lvalue); // Contenido de la variable
          String vrName = Variable.getvrn(lvalue); // Nombre de la variable
          Variable variable = Variable(vrName, vrValue, variableType);

          mainParser.registerVariable(variable);
          debugPrint(
              'Variable $vrName de tipo $variableType, $vrValue registrada en la linea $line');
        } // Fin de es una variable

        if (SundiParser.isToken(tokenName)) {
          SundiExpression token = SundiParser.getToken(tokenName);
          bool tokenEval = token.pattern.hasMatch(lvalue);
          debugPrint('Checking token $tokenName at line $line');
          if (!tokenEval) {
            mainParser.addError(SundiError(
                token: lvalue,
                error: Error.ERR_SYNTAX_ERROR,
                position: lvalue.indexOf(tokenName),
                line: line,
                path: filepath));
          }
          if (tokenEval) {
            SundiContentCode code = SundiContentCode(
                file: path.basename(file.path),
                path: filepath,
                token: token.name,
                code: token,
                value: lvalue,
                line: line,
                position: lvalue.indexOf(tokenName));
            List<SundiVariableInstance> instances =
                SundiParser.getvrInstances(lvalue, mainParser, line, file);
            code.instances = instances;
            await token.preload(code, main);
            mainParser.registerMainCode(code);
          }
        }
      }
    }
    debugPrint('Registradas ${(main.variables.length)} variables');
  }

  void printErrorStack([Set<SundiError>? errors]) {
    errors ??= mainParser.errors;
    if (errors.isEmpty) return;
    for (var error in errors) {
      error.show();
    }
    exit(-1);
  }

  void run() async {
    printErrorStack();
    if (main.errors.isEmpty) {
      for (var code in main.code) {
        await code.code.runner(code, main);
      }
    }
  }
}
