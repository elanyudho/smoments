import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smoments/res/assets.dart';
import 'package:smoments/res/colors.dart';
import 'package:smoments/utils/text_extension.dart';

class StoryItem extends StatefulWidget {
  final String username;
  final String caption;
  final String image;
  final String date;

  const StoryItem({
    super.key,
    required this.username,
    required this.caption,
    required this.image,
    required this.date
  });

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  var isShowAll = false;
  var isShowMoreText = false;
  var showMoreText = 'Show more';

  @override
  Widget build(BuildContext context) {
    if (widget.caption.length > 196) isShowMoreText = true;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: ThemeColors.primaryColor,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.username.length > 100 ? '${widget.username.substring(0, 100)}...' : widget.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Flexible(flex: 1, child: SvgPicture.asset(assetVerified)),
                        Text(
                          ' · ${formatDateTime(widget.date)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.caption,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: isShowAll ? 100 : 5,
                    ),
                      isShowMoreText ? TextButton(
                      onPressed: () {
                         setState(() {
                           isShowAll = !isShowAll;
                         });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                      ),
                      child: Text(
                        isShowAll ? 'Show less' : 'Show more',
                        style: const TextStyle(fontSize: 16, color: ThemeColors.primaryColor),
                      ),
                    ): const SizedBox(height: 16,),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.image,
                        width: double.infinity, // Set the width of the image
                        height: 250, // Set the height of the image
                        fit: BoxFit.cover, // Adjust how the image is fitted within the dimensions
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.infinity, color: Colors.black26, height: 1)
      ],
    );
  }
}
