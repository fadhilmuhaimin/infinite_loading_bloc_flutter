import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_loading_bloc_flutter/bloc/post_bloc.dart';
import 'package:infinite_loading_bloc_flutter/ui/post_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController controller = ScrollController();
  PostBloc? bloc;

  void onScroll(){
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if(currentScroll == maxScroll) bloc?.add(PostEvent());
  }
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PostBloc>(context);
    controller.addListener(onScroll);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infinite List With BLoC"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state is PostUninitialized) {
            return const Center(
                child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ));
          } else {
            PostLoaded postLoaded = state as PostLoaded;
            return ListView.builder(
              controller: controller,
                itemCount: (postLoaded.hasReachedMax!)
                  ? postLoaded.posts!.length
                  : postLoaded.posts!.length +1 ,
                itemBuilder: (context, index) =>
                    (index < postLoaded.posts!.length)
                        ? PostItem(postLoaded.posts![index])
                        : Container(
                          child: const Center(
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(),
                              ),
                          ),
                        ));
          }
        }),
      ),
    );
  }
}
