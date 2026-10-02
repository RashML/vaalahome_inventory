import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inventory_app/features/auth/auth_service.dart';
import 'package:inventory_app/features/auth/data/auth_repository.dart';
import 'package:inventory_app/features/auth/data/pocketbase_auth_repository.dart';
import 'package:inventory_app/features/camera/permission/camera_permission_manager.dart';
import 'package:inventory_app/features/item/data/item_image_service.dart';
import 'package:inventory_app/features/camera/permission/permission_handler_camera_permission_manager.dart';
import 'package:inventory_app/features/order/data/draft_order_service.dart';
import 'package:inventory_app/shared/data/pocketbase_repository.dart';
import 'package:inventory_app/shared/navigation/app_router.dart';
import 'package:inventory_app/shared/data/repository.dart';
import 'package:inventory_app/shared/models/bundle.dart';
import 'package:inventory_app/shared/models/company.dart';
import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/item.dart';

final getIt = GetIt.instance;

/// Registers every repository behind its interface.
///
/// Pages/blocs resolve [AuthRepository] / `Repository<T>` from [getIt] and
/// never see PocketBase directly, so swapping to a mock or another backend
/// means changing only this function.
Future<void> setupLocator({String pocketBaseUrl = 'http://127.0.0.1:8090'}) async {
  final prefs = await SharedPreferences.getInstance();
  final authStore = AsyncAuthStore(
    save: (data) async => prefs.setString('pb_auth', data),
    initial: prefs.getString('pb_auth'),
    clear: () async => prefs.remove('pb_auth'),
  );
  final pb = PocketBase(pocketBaseUrl, authStore: authStore);
  getIt.registerSingleton<PocketBase>(pb);

  getIt.registerSingleton<AuthRepository>(PocketBaseAuthRepository(pb));
  getIt.registerSingleton<AuthService>(AuthService(getIt<AuthRepository>()));
  getIt.registerSingleton<AppRouter>(AppRouter(getIt<AuthService>()));

  // In-memory only: the order draft is a scratch pad, dropped on restart.
  getIt.registerSingleton<DraftOrderService>(DraftOrderService());

  getIt.registerSingleton<CameraPermissionManager>(
    PermissionHandlerCameraPermissionManager(),
  );

  getIt.registerSingleton<ItemImageService>(ItemImageService(pb));

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
