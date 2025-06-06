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
  final bootstrap = bootstraper();
  final hamLog = HamLogger(
    logger: bootstrap.logger,
    env: enviroment,
    flag: flag,
    appVersion: appVersion,
  );
  FlutterError.onError = (err) => hamLog.globalErrorLogger(
    error: err,
    stackTrace: err.stack ?? StackTrace.current,
  );

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await bootstrap.loadLogger(enviroment);
      Inyector.add<FlavorNotifier>(
        () =>
            FlavorNotifier(version: appVersion, flavor: enviroment, flag: flag),
      );
      hamLog.initialize();
      Inyector.add<HamLogger>(() => hamLog);

      await Inyector.addAsync<HamCache>(_loadCache);
      Inyector.add(GlobalKey<ScaffoldMessengerState>.new);
      Inyector.add(GlobalKey<ScaffoldState>.new);
      await bootstrap.bootstrap(enviroment);
      runApp(app());
    },
    (error, stack) => hamLog.globalErrorLogger(error: error, stackTrace: stack),
  );
}

Future<HamCache> _loadCache() async {
  final cache = await HamCache.constructor();
  return cache;
}
