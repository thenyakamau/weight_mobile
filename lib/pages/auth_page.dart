import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighter/utils/snackbar_widget.dart';

import '../bloc/auth/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);
  static const route = "/auth";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.loading:
            SnackBarWidget.loadingSnackBar(context);
            break;
          case AuthStatus.error:
            SnackBarWidget.errorSnackBar(
                context, state.error ?? "Error please try again");
            break;
          default:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            break;
        }
      },
      bloc: context.read<AuthCubit>(),
      child: Scaffold(
        body: Center(
          child: TextButton.icon(
            onPressed: () {
              context.read<AuthCubit>().loginAnonymously();
            },
            icon: Icon(Icons.person),
            label: Text("Sign In"),
          ),
        ),
      ),
    );
  }
}
