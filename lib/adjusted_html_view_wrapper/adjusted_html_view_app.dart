import 'package:flutter/widgets.dart';

import 'adjusted_html_view_wrapper.dart';

class AdjustedHtmlViewWrapperApp implements AdjustedHtmlViewWrapper {
  @override
  Widget build(String html) {
    return Text(html);
  }
}

AdjustedHtmlViewWrapper getAdjustedHtmlViewWrapper() => AdjustedHtmlViewWrapperApp();
