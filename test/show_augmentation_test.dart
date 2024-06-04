import 'dart:io';

import 'package:test/test.dart';
import 'package:test_util/test_util.dart';

void main() {
  test('Empty for nonexistent file', () async {
    await dartPubGet(workingDirectory: Directory.current.path + '/example');
    final content = await _run('nonexistent.txt');

    expect(content, '');
  });

  test('Empty for file without macro applications', () async {
    await dartPubGet(workingDirectory: Directory.current.path + '/example');
    final content = await _run('lib/hello_macro.dart');

    expect(content, '');
  });

  test('Augmentation for file with macro applications', () async {
    await dartPubGet(workingDirectory: Directory.current.path + '/example');
    final content = await _run('lib/main.dart');

    expect(
      content,
      File('test/main_augmentation.dart.txt').readAsStringSync(),
    );
  });
}

Future<String> _run(String filename) async {
  final result = await dartRun(
    [
      'show_augmentation',
      '--file=$filename',
    ],
    experiments: ['macros'],
    workingDirectory: Directory.current.path + '/example',
  );

  return result.stdout;
}
