import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_loading_bloc_flutter/bloc/post_bloc.dart';
import 'package:infinite_loading_bloc_flutter/ui/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider<PostBloc>(
            create: (context) => PostBloc()..add(PostEvent()),
            child: MainPage()),
            );
  }
}
