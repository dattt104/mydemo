import 'package:flutter/material.dart';
import 'package:business/video/provider/video_page_provider.dart';

class VideoDetails extends StatelessWidget {
  final VideoPageProvider viewModel;
  final Function()? onShare;
  const VideoDetails({
    Key? key,
    required this.viewModel,
    this.onShare,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String title = viewModel.getVideoSelected!.title;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 14,
            right: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 8),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Product Sans',
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  if (onShare != null) {
                    onShare!();
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
