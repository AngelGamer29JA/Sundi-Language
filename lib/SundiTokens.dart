import 'package:sundilang/Expressions/FileSystem/CreateFileExperssion.dart';
import 'package:sundilang/Expressions/FileSystem/DeteleteFileExpression.dart';
import 'package:sundilang/Expressions/FileSystem/ReadFileContentExpression.dart';
import 'package:sundilang/Expressions/FileSystem/ReadFileExpression.dart';
import 'package:sundilang/Expressions/FileSystem/WriteFileExpression.dart';
import 'package:sundilang/Expressions/FileSystem/WritelnFileExpression.dart';
import 'package:sundilang/Expressions/PromptExpression.dart';
import 'package:sundilang/Expressions/SendExpression.dart';
import 'package:sundilang/Expressions/SendlnExpression.dart';
import 'package:sundilang/Expressions/base/SundiExpression.dart';

Set<SundiExpression> sundiTokens = {
  SendlnExpression(),
  PromptExpression(),
  SendExpression(),
  DeleteFileExpression(),
  CreateFileExpression(),
  ReadFileExpression(),
  ReadFileContentExpression(),
  WriteFileExpression(),
  WritelnFileExpression()
};

abstract class SundiDeclarations {
  RegExp get Variable {
    return RegExp(r'^(\w+\s=\s".+")'); // Identificador de variable
  }
  //RegExp get Variable { return RegExp(r'^(fun\s\w+)(\()[a-z,]+(\)):|^(fun\s\w+)(\()(\)):')}
  //RegExp get Variable { return RegExp(r'([a-zA-z]+\(\))')}
  //RegExp get Variable { return RegExp(r'(if (@{.*})\s(==|!=|>|<|<=|>=|is equal|is not equal)\s(".*"|[0-9.]):')}
}
