import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_info.dart';
import 'core/database/app_database.dart';
import 'core/navigation/navigation_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/auth_gate.dart';
import 'features/auth/services/auth_repository.dart';
import 'features/auth/services/sqlite_auth_repository.dart';
import 'features/home/controllers/home_controller.dart';
import 'features/outfits/controllers/outfits_controller.dart';
import 'features/outfits/services/outfit_repository.dart';
import 'features/outfits/services/sqlite_outfit_repository.dart';
import 'features/studio/controllers/studio_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await AppDatabase.open();
  runApp(
    ModooApp(
      authRepository: SqliteAuthRepository(database),
      outfitRepository: SqliteOutfitRepository(database),
    ),
  );
}

class ModooApp extends StatelessWidget {
  const ModooApp({
    super.key,
    required this.authRepository,
    required this.outfitRepository,
  });

  final AuthRepository authRepository;
  final OutfitRepository outfitRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(authRepository)),
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProxyProvider<AuthController, OutfitsController>(
          create: (_) => OutfitsController(outfitRepository),
          update: (_, auth, outfits) => outfits!..bindUser(auth.user?.id),
        ),
        ChangeNotifierProxyProvider<AuthController, StudioController>(
          create: (_) => StudioController(),
          update: (_, auth, studio) => studio!..bindUser(auth.user?.id),
        ),
      ],
      child: MaterialApp(
        title: AppInfo.name,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}
