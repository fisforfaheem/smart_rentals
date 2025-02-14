import 'dart:io';

void main() {
  final directory = Directory('lib');
  updateImports(directory);
}

void updateImports(Directory dir) {
  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = entity.readAsStringSync();
      content = content.replaceAll(
        "package:your_app_name/",
        "package:car_rental_app/",
      );
      entity.writeAsStringSync(content);
      print('Updated ${entity.path}');
    }
  }
} 