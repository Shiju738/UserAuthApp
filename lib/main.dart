import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_router.dart';
import 'core/utils/constants.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc();
    authBloc.add(AppStarted());

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routerConfig: AppRouter(authBloc).router,
    );
  }
}
