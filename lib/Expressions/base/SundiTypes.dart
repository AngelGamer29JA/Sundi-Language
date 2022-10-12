abstract class TYPE {
  static VariableType get STRING {
    return VariableType(RegExp(r'((?=").*(?<="))'), 'STRING', 0x000001);
  }

  static VariableType get NUMBER {
    return VariableType(RegExp(r'([0-9.]+)'), 'NUMBER', 0x000002);
  }

  static VariableType get VARIABLE_INSTANCE {
    return VariableType(
        RegExp(r'(?<={)\w+(?=})'), 'VARIABLE_INSTANCE', 0x000003);
  }

  static VariableType get BOOL {
    return VariableType(RegExp(r'(true|false)'), 'NULL', 0x000004);
  }

  static VariableType get NULL {
    return VariableType(RegExp(r'(undefined|null)'), 'NULL', 0x000005);
  }

  static VariableType get FILE {
    return VariableType(RegExp(''), 'FILE', 0x000005);
  }
}

/// Declara un nuevo tipo de variable
class VariableType {
  late RegExp PATTERN;
  int CODE = 0;
  String IDENTIFIER = '';
  VariableType(RegExp pattern, String ident, int code) {
    PATTERN = pattern;
    CODE = code;
    IDENTIFIER = ident;
  }
}
