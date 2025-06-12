import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Widget buildShimmerGrid() {
  return GridView.builder(
    padding: const EdgeInsets.all(16.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 48.0, width: 48.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Container(height: 16.0, width: 60.0, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

Widget buildShimmerList() {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(radius: 26, backgroundColor: Colors.white),
          title: Container(height: 16.0, color: Colors.white),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Container(height: 14.0, color: Colors.white),
            ],
          ),
        ),
      ),
    ),
  );
}
