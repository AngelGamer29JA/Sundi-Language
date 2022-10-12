import 'dart:io' as io show File, FileSystemEntity, exit;

import 'package:sundilang/SundiCore.dart';
import 'package:sundilang/SundiEnviroment.dart';
import 'package:sundilang/utils.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty && Enviroment.debug == false) {
    errorPrint(Error.ERR_NO_ARGUMENTS.message, Error.ERR_NO_ARGUMENTS.TYPE);
    print('Use --help to show information');
    io.exit(-1);
  } else if (arguments.isNotEmpty) {
    if (arguments[0] == '--help') {
      print(
          '''${Sundi.NAME} - ${Enviroment.version} (${Enviroment.versionType})
      \t--help\tInformacion de comandos
      
      sundi <file> to execute script''');
      io.exit(-1);
    }
  }
  String filename =
      (Enviroment.debug ? 'examples\\helloworld.sdi' : arguments[0]);
  var file = io.File(filename);
  try {
    SundiCore MainInstance = SundiCore(file);

    if (SundiCore.checkExt(filename) == false) {
      throw Error.ERR_FILE_EXT;
    }
    if (!await file.exists()) throw Error.ERR_NOT_EXIST_SELECTED;
    if (!await io.FileSystemEntity.isFile(filename)) {
      throw Error.ERR_FILE_IS_DIR;
    }

    if (await io.FileSystemEntity.isFile(filename)) {
      await MainInstance.runInstance();
    }
  } catch (err) {
    if (err is ErrorType) {
      errorPrint(err.message, err.TYPE);
    }
  }
}
