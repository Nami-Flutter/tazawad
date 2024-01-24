import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as html;
import 'package:nb_utils/nb_utils.dart';


class YouTubeEmbedWidget extends StatelessWidget {
  final String videoId;
  final bool? fullIFrame;

  YouTubeEmbedWidget(this.videoId, {this.fullIFrame});

  @override
  Widget build(BuildContext context) {
    log(videoId);
    return html. HtmlWidget(
       '''
       <html>
       <iframe height="230" style="width:100%" src="https://www.youtube.com/embed/$videoId" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen">
       </iframe></html>
       ''',
    );
  }
}
