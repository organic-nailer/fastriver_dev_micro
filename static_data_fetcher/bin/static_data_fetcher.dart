import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  var myDir = Directory.current;
  FileSystemEntity? config;
  await for (var file in myDir.list()) {
    if (file.uri.pathSegments.last == "pubspec.yaml") {
      config = file;
      break;
    }
  }
  if (config == null) {
    throw Exception("pubspec.yaml is missing");
  }

  // get config
  final configYaml = await File(config.path).readAsString();
  final configMap = loadYaml(configYaml) as Map;
  if (!configMap.containsKey("static_data_fetcher")) {
    throw Exception("config not found");
  }

  List data = configMap["static_data_fetcher"];
  Map<String, String> results = {};
  for (final item in data) {
    String label = item["label"];
    String url = item["url"];
    String type = item["type"];
    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("failed to fetch");
    }
    if (item.containsKey("ignore_attributes")) {
      if (type == "json") {
        var decoded = jsonDecode(response.body) as List<dynamic>;
        for (final e in decoded) {
          for (final attr in item["ignore_attributes"]) {
            e.remove(attr);
          }
        }
        results[label] = jsonEncode(decoded);
      } else if (type == "xml") {
        var document = XmlDocument.parse(response.body);
        for (final d in document.descendantElements) {
          for (final attr in item["ignore_attributes"]) {
            if (d.name.local == attr) {
              d.innerXml = "";
              break;
            }
          }
        }
        results[label] = document.toString();
      }
    } else {
      results[label] = response.body;
    }
  }
  generateData(results);
  print("generated");
}

Future<void> generateData(Map<String, String> data) async {
  final currentDir = Directory.current.path;
  var outFile = File("$currentDir/lib/static_fetched_data.g.dart");
  if (outFile.existsSync()) {
    // if data already exists in dry mode, skip overwriting.
    outFile.deleteSync();
  }
  outFile.createSync();
  var sink = outFile.openWrite();
  final staticDataDeclarations = <String>[];
  for (final item in data.entries) {
    final privateName = "_\$${item.key}Data";
    sink.write('const $privateName = """${item.value}""";\n');
    staticDataDeclarations
        .add("static const String ${item.key}Data = $privateName;");
  }
  final dataStoreDeclaration = """
class StaticFetchedDataStore {
  ${staticDataDeclarations.join("\n  ")}
}
""";
  sink.write(dataStoreDeclaration);
  sink.close();
}
