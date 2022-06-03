import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class Imagewid extends StatelessWidget {
  const Imagewid({Key? key, this.url, required this.height, required this.width}) : super(key: key);
  final url;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,height: height,width: width,fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Shimmer.fromColors(
            baseColor: Colors.red,
            highlightColor: Colors.yellow,
            child: Container(height: height,width: width,color: Colors.grey[70],),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );


  }
}
