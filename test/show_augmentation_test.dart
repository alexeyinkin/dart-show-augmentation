import 'dart:io';

import 'package:test/test.dart';
import 'package:test_util/test_util.dart';

void main() {
  setUp(() async {
    await dartPubGet(workingDirectory: Directory.current.path + '/example');
  });

  test('Empty for nonexistent file', () async {
    const file = 'nonexistent.txt';
    for (final lineNumbers in [true, false]) {
      final result = await _run(
        file,
        lineNumbers: lineNumbers,
        expectedExitCode: 1,
      );

      expect(result.stderr, contains('File not found: $file'));
    }
  });

  test('Empty for file without macro applications', () async {
    for (final lineNumbers in [true, false]) {
      final result = await _run(
        'lib/hello_macro.dart',
        lineNumbers: lineNumbers,
      );

      expect(result.stdout, '');
    }
  });

  test('Augmentation for file with macro applications', () async {
    final result = await _run('lib/main.dart', lineNumbers: false);

    expect(
      result.stdout,
      File('test/main_augmentation.dart.txt').readAsStringSync(),
    );
  });

  test('Augmentation for file with macro applications, line numbers', () async {
    final result = await _run('lib/main.dart', lineNumbers: true);

    expect(
      result.stdout,
      File('test/main_augmentation_line_numbers.dart.txt')
          .readAsStringSync()
          .replaceAll('⎵', ' '),
    );
  });
}

Future<ProcessResult> _run(
  String filename, {
  required bool lineNumbers,
  int expectedExitCode = 0,
}) async {
  final result = await dartRun(
    [
      'show_augmentation',
      '--file=$filename',
      if (lineNumbers) '--line-numbers',
    ],
    expectedExitCode: expectedExitCode,
    experiments: ['macros'],
    workingDirectory: Directory.current.path + '/example',
  );

  return result;
}
