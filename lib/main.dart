import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:post_api_service/post_api_service.dart';
import 'package:provider/provider.dart';

void main() {
  final postApiService = PostApiService.create();
  runApp(
    Provider(
      create: (_) => postApiService,
      dispose: (_, PostApiService service) => service.client.dispose(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Chopper Demo"),
        ),
        body: FutureBuilder<Response>(
          future: Provider.of<PostApiService>(context).getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // print('dữ liệu từ API: ${snapshot.data!.bodyString}');
              final List posts = json.decode(snapshot.data!.bodyString);
              print('post: $posts');
              final List limitedPosts =
                  posts.take(4).toList(); // giới hạn lại số lượng lấy
              print('số lượng bài viết: ${posts.length}');
              return _buildPosts(limitedPosts);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _buildPosts(List posts) {
  return ListView.builder(
    itemCount: 1, // giới hạng số lượng hiển thị từ số lấy về
    itemBuilder: (context, index) {
      final post = posts[index];
      return ListTile(
        title: Text(
          post['title'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(post['body']),
      );
    },
  );
}
