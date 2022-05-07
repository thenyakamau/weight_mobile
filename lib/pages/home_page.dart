import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighter/bloc/auth/auth_cubit.dart';
import 'package:weighter/bloc/weight/weight_bloc.dart';
import 'package:weighter/bloc/weight_crud/weight_crud_cubit.dart';
import 'package:weighter/model/weight.dart';
import 'package:weighter/utils/snackbar_widget.dart';
import 'package:weighter/utils/spacer.dart';

import '../di/injection.dart';
import 'weight_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Weight> _weight = [];
  final _crudBloc = getIt<WeightCrudCubit>();
  @override
  void initState() {
    super.initState();
    context.read<WeightBloc>().add(WatchWeightEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _crudBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (create) => _crudBloc)],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
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
          ),
          BlocListener<WeightBloc, WeightState>(
            listener: (context, state) {
              switch (state.status) {
                case WeightStatus.success:
                  _weight = state.weight;
                  break;
                default:
                  break;
              }
            },
          ),
          BlocListener<WeightCrudCubit, WeightCrudState>(
            bloc: _crudBloc,
            listener: (context, state) {
              switch (state.status) {
                case WeightCrudStatus.initial:
                  ScaffoldMessenger.of(context)..hideCurrentSnackBar();
                  break;
                case WeightCrudStatus.success:
                  ScaffoldMessenger.of(context)..hideCurrentSnackBar();
                  break;
                case WeightCrudStatus.error:
                  SnackBarWidget.errorSnackBar(
                      context, state.error ?? "Error please try again");
                  break;
                case WeightCrudStatus.loading:
                  SnackBarWidget.loadingSnackBar(context);
                  break;
              }
            },
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            actions: [
              TextButton.icon(
                onPressed: () => showDialog<bool>(
                  context: context,
                  builder: (builder) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value != null && value) {
                    context.read<AuthCubit>().logout();
                  }
                }),
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                label: Text(
                  "LOGOUT",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          body: BlocBuilder<WeightBloc, WeightState>(
            builder: (context, state) {
              switch (state.status) {
                case WeightStatus.loading:
                  return Center(child: CircularProgressIndicator());
                case WeightStatus.error:
                  return Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<WeightBloc>().add(WatchWeightEvent()),
                      child: Text("RETRY"),
                    ),
                  );
                default:
                  break;
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: _weight.length,
                      separatorBuilder: (_, __) => VSpacer(space: 2),
                      padding: EdgeInsets.all(10),
                      itemBuilder: (_, i) {
                        final _model = _weight[i];
                        return Card(
                          child: ListTile(
                            title: Text("Weight (KGS)"),
                            subtitle:
                                Text("${_model.weight.toStringAsFixed(2)}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => showDialog<double>(
                                    context: context,
                                    builder: (builder) =>
                                        WeightDialog(weight: _model),
                                  ).then((value) {
                                    if (value != null) {
                                      _crudBloc.updateWeight(
                                          _model.copyWith(weight: value));
                                    }
                                  }),
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => showDialog<bool>(
                                    context: context,
                                    builder: (builder) => AlertDialog(
                                      title: Text("Delete"),
                                      content: Text(
                                          "Are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).then((value) {
                                    if (value != null && value) {
                                      _crudBloc.deleteWeight(_model);
                                    }
                                  }),
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  VSpacer(
                    space: 2,
                  ),
                  SafeArea(
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () => showDialog<double>(
                          context: context,
                          builder: (builder) => WeightDialog(),
                        ).then((value) {
                          if (value != null) {
                            _crudBloc.setWeight(Weight.create(value));
                          }
                        }),
                        label: Text("Record Weight"),
                        icon: Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
