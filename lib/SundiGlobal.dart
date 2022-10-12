import 'package:sundilang/Expressions/base/SundiVariables.dart';
import 'package:system_info2/system_info2.dart';

Set<Variable> globalVariables = {
  Variable('SYSTEM_NAME', SysInfo.operatingSystemName, 'STRING'),
  Variable('SYSTEM_VERSION', SysInfo.operatingSystemVersion, 'STRING'),
  Variable('KERNEL_ARCH', SysInfo.kernelArchitecture, 'STRING'),
  Variable('KERNEL_NAME', SysInfo.kernelName, 'STRING'),
  Variable('KERNEL_VERSION', SysInfo.kernelVersion, 'STRING'),
  Variable('USER_PATH', SysInfo.userDirectory, 'STRING'),
  Variable('USER_NAME', SysInfo.userName, 'STRING'),
  Variable('CPU_CORES', SysInfo.cores.length.toString(), 'NUMBER'),
};
