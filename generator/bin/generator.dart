import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;

const String baseUrl = "https://fastriver-dev.microcms.io/api/v1";

void main() async {
  dotenv.load();
  final apiKey = dotenv.env["API_KEY"];
  if (apiKey == null) {
    print("API_KEY doesn't exist in .env");
    return;
  }
  var myDir = Directory.current;
  FileSystemEntity? config;
  await for (var file in myDir.list()) {
    if (file.uri.pathSegments.last == "generator.config.yaml") {
      config = file;
      break;
    }
  }
  if (config == null) {
    print("generator.config.yaml is missing");
    return;
  }

  final configYaml = await File(config.path).readAsString();
  final configMap = loadYaml(configYaml);
  print(configMap);

  //ファイルへの書き込み
  var outFile = File(myDir.path + "/lib/micro_cms_data.gen.g.dart");
  if (outFile.existsSync()) {
    outFile.deleteSync();
  }
  outFile.createSync();
  var sink = outFile.openWrite();
  sink.write("import 'dart:convert';\n\n");
  for (var element in (configMap["apis"] as List)) {
    final endpoint = element["endpoint"];
    final dataType = element["type"];
    final res = await getMicroData(endpoint, apiKey);
    final privateName = "_\$${endpoint}Data";
    sink.write("const $privateName = r'$res';\n");
    sink.write(
        "Map<String, dynamic> ${endpoint}Data() => jsonDecode($privateName);\n");
  }
  sink.close();
}

Future<String> getMicroData(String endpoint, String apiKey) async {
  var url = baseUrl + "/$endpoint";
  var res =
      await http.get(Uri.parse(url), headers: {"X-MICROCMS-API-KEY": apiKey});
  return res.body;
}
