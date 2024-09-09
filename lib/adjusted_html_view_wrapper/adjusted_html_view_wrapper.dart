import 'package:flutter/widgets.dart';

import 'adjusted_html_view_stub.dart'
    if (dart.library.html) 'adjusted_html_view_web.dart'
    if (dart.library.io) 'adjusted_html_view_app.dart';

abstract class AdjustedHtmlViewWrapper {
  Widget build(String html);

  factory AdjustedHtmlViewWrapper() => getAdjustedHtmlViewWrapper();
}