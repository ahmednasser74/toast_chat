import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImageWithFirstCharWidget extends StatelessWidget {
  final String avatar;
  final String fullName;
  final double imageSize;

  CircleImageWithFirstCharWidget({
    required this.avatar,
    required this.fullName,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      radius: imageSize,
      child: ClipOval(
        child: !avatar.contains('connectycube')
            ? Text(
                getFirstChar(string: fullName.toUpperCase(), limitTo: 1),
                style: TextStyle(fontSize: 20),
              )
            : CachedNetworkImage(
                imageUrl: avatar.toString(),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, url, progress) =>
                    CircularProgressIndicator(),
              ),
      ),
    );
  }

  String getFirstChar({required String string, required int limitTo}) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (limitTo); i++) {
      buffer.write(split[i][0]);
    }
    return buffer.toString();
  }
}
