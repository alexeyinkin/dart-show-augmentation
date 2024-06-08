import 'dart:io';

import 'package:test/test.dart';
import 'package:test_util/test_util.dart';

void main() {
  setUp(() async {
    await dartPubGet(workingDirectory: Directory.current.path + '/example');
  });

  test('Empty for nonexistent file', () async {
    for (final lineNumbers in [true, false]) {
      final content = await _run('nonexistent.txt', lineNumbers: lineNumbers);

      expect(content, '');
    }
  });

  test('Empty for file without macro applications', () async {
    for (final lineNumbers in [true, false]) {
      final content = await _run(
        'lib/hello_macro.dart',
        lineNumbers: lineNumbers,
      );

      expect(content, '');
    }
  });

  test('Augmentation for file with macro applications', () async {
    final content = await _run('lib/main.dart', lineNumbers: false);

    expect(
      content,
      File('test/main_augmentation.dart.txt').readAsStringSync(),
    );
  });

  test('Augmentation for file with macro applications, line numbers', () async {
    final content = await _run('lib/main.dart', lineNumbers: true);

    expect(
      content,
      File('test/main_augmentation_line_numbers.dart.txt').readAsStringSync(),
    );
  });
}

Future<String> _run(String filename, {required bool lineNumbers}) async {
  final result = await dartRun(
    [
      'show_augmentation',
      '--file=$filename',
      if (lineNumbers) '--line-numbers',
    ],
    experiments: ['macros'],
    workingDirectory: Directory.current.path + '/example',
  );

  return result.stdout;
}
