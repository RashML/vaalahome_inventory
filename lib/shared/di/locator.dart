import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../features/auth/auth_service.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/pocketbase_auth_repository.dart';
import '../../features/camera/permission/camera_permission_manager.dart';
import '../../features/camera/permission/permission_handler_camera_permission_manager.dart';
import '../data/pocketbase_repository.dart';
import '../navigation/app_router.dart';
import '../data/repository.dart';
import '../models/bundle.dart';
import '../models/company.dart';
import '../models/currency.dart';
import '../models/item.dart';

final getIt = GetIt.instance;

/// Registers every repository behind its interface.
///
/// Pages/blocs resolve [AuthRepository] / `Repository<T>` from [getIt] and
/// never see PocketBase directly, so swapping to a mock or another backend
/// means changing only this function.
void setupLocator({String pocketBaseUrl = 'http://127.0.0.1:8090'}) {
  final pb = PocketBase(pocketBaseUrl);
  getIt.registerSingleton<PocketBase>(pb);

  getIt.registerSingleton<AuthRepository>(PocketBaseAuthRepository(pb));
  getIt.registerSingleton<AuthService>(AuthService(getIt<AuthRepository>()));
  getIt.registerSingleton<AppRouter>(AppRouter(getIt<AuthService>()));

  getIt.registerSingleton<CameraPermissionManager>(
    PermissionHandlerCameraPermissionManager(),
  );

  getIt.registerSingleton<Repository<Company>>(
    PocketBaseRepository<Company>(
      pb,
      collection: Company.collection,
      fromRecord: Company.fromRecord,
      toJson: (company) => company.toJson(),
    ),
  );

  getIt.registerSingleton<Repository<Bundle>>(
    PocketBaseRepository<Bundle>(
      pb,
      collection: Bundle.collection,
      fromRecord: Bundle.fromRecord,
      toJson: (bundle) => bundle.toJson(),
    ),
  );

  getIt.registerSingleton<Repository<Currency>>(
    PocketBaseRepository<Currency>(
      pb,
      collection: Currency.collection,
      fromRecord: Currency.fromRecord,
      toJson: (currency) => currency.toJson(),
    ),
  );

  getIt.registerSingleton<Repository<Item>>(
    PocketBaseRepository<Item>(
      pb,
      collection: Item.collection,
      fromRecord: Item.fromRecord,
      toJson: (item) => item.toJson(),
    ),
  );
}
