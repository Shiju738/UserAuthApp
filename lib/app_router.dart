import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_state.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  GoRouter get router => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider.value(
            value: authBloc,
            child: BlocBuilder<AuthBloc, AuthState>(
              bloc: authBloc,
              builder: (context, authState) {
                if (authState is AuthLoggedIn) {
                  return const HomePage();
                } else {
                  return const LoginPage();
                }
              },
            ),
          );
        },
      ),
    ],
  );
}
