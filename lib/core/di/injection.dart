import 'package:get_it/get_it.dart';

import 'repository_modules.dart';
import 'service_modules.dart';
import 'usecase_modules.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  registerServices(sl);
  registerRepositories(sl);
  registerUseCases(sl);
}
