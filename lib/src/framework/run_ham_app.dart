import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ham/src/cache/cache.dart';
import 'package:ham/src/core/core.dart';
import 'package:ham/src/flavors/flavors.dart';
import 'package:ham/src/framework/bootstrap.dart';
import 'package:ham/src/log/log.dart';

///[runHamApp] is the main entry point of the ham app.
Future<void> runHamApp({
  required Widget Function() app,
  required Enviroment enviroment,
  required Flag flag,
  required Bootstrap Function() bootstraper,
  required String appVersion,
}) async {
  Inyector.add<FlavorNotifier>(
    () => FlavorNotifier(version: appVersion, flavor: enviroment, flag: flag),
  );
  final bootstrap = bootstraper();
  await bootstrap.loadLogger();
  final hamLog = HamLogger(logService: LogService(), logger: bootstrap.logger);
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Inyector.add<HamLogger>(() => hamLog);
    await Inyector.addAsync<HamCache>(HamCache.constructor);
    Inyector.add(GlobalKey<ScaffoldMessengerState>.new);
    Inyector.add(GlobalKey<ScaffoldState>.new);
    await bootstrap.bootstrap();
    runApp(app());
  }, hamLog.globalErrorLogger);
}
