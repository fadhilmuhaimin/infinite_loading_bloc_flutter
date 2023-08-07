import 'package:bloc/bloc.dart';
import 'package:infinite_loading_bloc_flutter/model/post.dart';

class PostEvent {}

abstract class PostState {}

class PostUninitialized extends PostState {}

class PostLoaded extends PostState {
  List<Post>? posts;
  bool? hasReachedMax;

  PostLoaded({this.posts, this.hasReachedMax});

  PostLoaded copyWith({List<Post>? posts, bool? hasReachedMax}) {
    return PostLoaded(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostUninitialized()) {
    List<Post> posts;
    on<PostEvent>((event, emit) async {
      if (state is PostUninitialized) {
        posts = await Post.connectToAPI(0, 10);
        emit(PostLoaded(posts: posts, hasReachedMax: false));
      } else {
        PostLoaded postLoaded = state as PostLoaded;
        posts = await Post.connectToAPI(postLoaded.posts!.length, 10);
        (posts.isEmpty)
            ? emit(postLoaded.copyWith(hasReachedMax: true))
            : emit(PostLoaded(
                posts: postLoaded.posts! + posts, hasReachedMax: false));
      }
    });
  }
}
