import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighter/bloc/auth/auth_cubit.dart';
import 'package:weighter/bloc/weight/weight_bloc.dart';
import 'package:weighter/di/injection.dart';
import 'package:weighter/pages/auth_page.dart';
import 'package:weighter/pages/home_page.dart';
import 'package:weighter/pages/splash_page.dart';
import 'package:weighter/utils/size_config.dart';

import 'bloc/weight_crud/weight_crud_cubit.dart';
import 'pages/unknown_route.dart';
import 'utils/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  await Firebase.initializeApp();
  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navKey = GlobalKey<NavigatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  // This widget is the root of your application.

  final _authBloc = getIt<AuthCubit>();
  final _weightBloc = getIt<WeightBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.close();
    _weightBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _authBloc),
        BlocProvider(create: (create) => _weightBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthStatus.initial:
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  break;

                case AuthStatus.loggedIn:
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  _navKey.currentState?.pushNamedAndRemoveUntil(
                    HomePage.route,
                    (route) => false,
                  );
                  break;
                case AuthStatus.loggedOut:
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  _navKey.currentState?.pushNamedAndRemoveUntil(
                    AuthPage.route,
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
          )
        ],
        child: MaterialApp(
          builder: (context, child) {
            SizeConfig.instance.init(context);
            return child!;
          },
          navigatorKey: _navKey,
          scaffoldMessengerKey: _scaffoldKey,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onUnknownRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (builder) => UnknownRoute(),
          ),
          onGenerateRoute: (settings) {
            final args = settings.arguments;
            switch (settings.name) {
              case SplashPage.route:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => SplashPage(),
                );
              case AuthPage.route:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => AuthPage(),
                );
              case HomePage.route:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => HomePage(),
                );
              default:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (builder) => UnknownRoute(),
                );
            }
          },
        ),
      ),
    );
  }
}
