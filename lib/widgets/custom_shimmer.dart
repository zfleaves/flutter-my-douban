import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatefulWidget {
  final int totalLines;
  const CustomShimmer({super.key, required this.totalLines});

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> {

  List<Widget> _getShimmerItem() {
    List<Widget> list = [];
    for (var i = 0; i < widget.totalLines; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              BannerPlaceholder(),
              NamePlaceholder(width: double.infinity,),
              SizedBox(height: 10.0),
              TitlePlaceholder(width: double.infinity),
              SizedBox(height: 6.0),
              TitlePlaceholder(width: 120),
              SizedBox(height: 16.0),
              TitlePlaceholder(width: double.infinity),
            ],
          ),
        )
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: _getShimmerItem(),
            // children: [
            //   BannerPlaceholder(),
            //   NamePlaceholder(width: double.infinity,),
            //   SizedBox(height: 10.0),
            //   TitlePlaceholder(width: double.infinity),
            //   SizedBox(height: 6.0),
            //   TitlePlaceholder(width: 120),
            //   SizedBox(height: 16.0),
            //   TitlePlaceholder(width: double.infinity),
            // ],
          ),
        ));
  }
}

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.0,
      margin: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NamePlaceholder extends StatelessWidget {
  final double width;
  const NamePlaceholder({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 24.0,
            margin: const EdgeInsets.only(right: 6),
            color: Colors.white,
          ),
          Container(
            width: 100,
            height: 24.0,
            color: Colors.white,
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 80,
                height: 24.0,
                margin: const EdgeInsets.only(right: 6),
                color: Colors.white,
              ),
            )
          )
        ],
      ),
    );
  }
}


class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 24.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    Key? key,
    required this.lineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96.0,
            height: 72.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
