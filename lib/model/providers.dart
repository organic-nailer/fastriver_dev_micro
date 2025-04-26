import 'package:fastriver_dev_micro/model/blogs_hatena.dart';
import 'package:fastriver_dev_micro/model/blogs_hexo.dart';
import 'package:fastriver_dev_micro/model/blogs_qiita.dart';
import 'package:fastriver_dev_micro/model/blogs_zenn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blogsZennProvider = Provider((_) => BlogsZenn());

final blogsQiitaProvider = Provider((_) => BlogsQiita());

final blogsHatenaProvider = Provider((_) => BlogsHatena());

final blogsHexoProvider = Provider((_) => BlogsHexo());

final blogsProvider = Provider((ref) {
  var zennProvider = ref.read(blogsZennProvider);
  var qiitaProvider = ref.read(blogsQiitaProvider);
  var hatenaProvider = ref.read(blogsHatenaProvider);
  var hexoProvider = ref.read(blogsHexoProvider);
  return [
    ...zennProvider.get(),
    ...qiitaProvider.get(),
    ...hatenaProvider.get(),
    ...hexoProvider.get(),
  ]..sort(((a, b) => -a.publishedAt.compareTo(b.publishedAt)));
});
