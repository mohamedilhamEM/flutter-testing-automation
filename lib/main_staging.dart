import 'package:testingapp/app/app.dart';
import 'package:testingapp/bootstrap.dart';
import 'package:testingapp/utils/utils.dart';

Future<void> main() async {
  await bootstrap(() => const TestingApp(), environment: AppEnvironment.staging);
}
