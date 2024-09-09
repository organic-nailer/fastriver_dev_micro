import 'package:adjusted_html_view_web/adjusted_html_view_web.dart';
import 'package:flutter/widgets.dart';

import 'adjusted_html_view_wrapper.dart';

class AdjustedHtmlViewWrapperWeb implements AdjustedHtmlViewWrapper {
  @override
  Widget build(String html) {
    return AdjustedHtmlView(htmlText: html);
  }
}

AdjustedHtmlViewWrapper getAdjustedHtmlViewWrapper() => AdjustedHtmlViewWrapperWeb();