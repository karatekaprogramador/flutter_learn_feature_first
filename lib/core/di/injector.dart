import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_learn_feature_first/features/auth/auth.dart';

final GetIt injector = GetIt.instance;

Future<void> setupInjector() async {
  if (injector.isRegistered<AuthCubit>()) {
    return;
  }

  injector.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    ),
  );

  injector.registerLazySingleton<InsforgeAuthService>(
    () => InsforgeAuthService(dio: injector<Dio>()),
  );

  injector.registerLazySingleton<AuthRepository>(
    () => AuthRepository(injector<InsforgeAuthService>()),
  );

  injector.registerLazySingleton<AuthCubit>(
    () => AuthCubit(injector<AuthRepository>()),
  );
}
