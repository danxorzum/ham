import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:ham/src/cache/cache.dart';
import 'package:ham/src/core/core.dart';
import 'package:ham/src/flavors/flavors.dart';
import 'package:ham/src/framework/bootstrap.dart';
import 'package:ham/src/log/log.dart';

///[runHamApp] is the main entry point of the ham app.
Future<void> runHamApp({
  required Widget app,
  required Enviroment enviroment,
  required Flag flag,
  required Bootstrap bootstrap,
  required String appVersion,
}) async {
  Inyector.add<FlavorNotifier>(
    () => FlavorNotifier(version: appVersion, flavor: enviroment, flag: flag),
  );
  await bootstrap.loadLogger();
  final hamLog = HamLogger(logService: LogService(), logger: bootstrap.logger);
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Inyector.add<HamLogger>(() => hamLog);
    await Inyector.addAsync<HamCache>(HamCache.constructor);
    await bootstrap.bootstrap();
    runApp(app);
  }, hamLog.globalErrorLogger);
}

// }) async {
//   BindingBase.debugZoneErrorsAreFatal = true;
//   WidgetsFlutterBinding.ensureInitialized();
//   Inyector.add<HamLogger>(
//     () => HamLogger(logService: LogService(), logger: bootstrap.logger),
//   );
//   await Inyector.addAsync<HamCache>(HamCache.constructor);
//   Inyector.add<FlavorNotifier>(
//     () => FlavorNotifier(version: appVersion, flavor: enviroment, flag: flag),
//   );
//   runZonedGuarded(() {
//     bootstrap.bootstrap().then((_) {
//       runApp(app);
//     });
//   }, Inyector.get<HamLogger>().globalErrorLogger);
// }
