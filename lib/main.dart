import 'package:flutter/widgets.dart';
import 'package:tapir_test/src/di/injection.dart';
import 'package:tapir_test/src/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const HarmonyApp());
}
