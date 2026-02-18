import 'package:my_secure_app/app/app.dart';
import 'package:my_secure_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
