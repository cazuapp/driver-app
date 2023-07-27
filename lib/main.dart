import 'package:flutter/material.dart';

Future<void> main() async {

  AppInstance instance = AppInstance();
  await instance.init();

  runApp(App(instance: instance));
}


class App extends StatelessWidget {
  final AppInstance instance;

  const App({super.key, required this.instance});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc(instance: instance)),
      ],
      child: const AppView(),
    );
  }
}

