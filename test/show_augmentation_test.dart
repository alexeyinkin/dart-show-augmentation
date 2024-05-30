import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Empty for nonexistent file', () async {
    await _pubGet();
    final content = await _run('nonexistent.txt');

    expect(content, '');
  });

  test('Empty for file without macro applications', () async {
    await _pubGet();
    final content = await _run('lib/hello_macro.dart');

    expect(content, '');
  });

  test('Augmentation for file with macro applications', () async {
    await _pubGet();
    final content = await _run('lib/hello_client.dart');

    expect(
      content,
      File('test/hello_client_augmentation.dart.txt').readAsStringSync(),
    );
  });
}

Future<void> _pubGet() async {
  final process = await Process.start(
    'dart',
    [
      'pub',
      'get',
    ],
    workingDirectory: Directory.current.path + '/example',
  );

  final exitCode = await process.exitCode;
  final stderr = await process.stderr.toJointString();

  expect(exitCode, 0, reason: stderr);
  expect(stderr, '');
}

Future<String> _run(String filename) async {
  final process = await Process.start(
    'dart',
    [
      '--enable-experiment=macros',
      'run',
      'show_augmentation',
      '--file=$filename',
    ],
    workingDirectory: Directory.current.path + '/example',
  );

  final exitCode = await process.exitCode;
  final stderr = await process.stderr.toJointString();
  expect(exitCode, 0, reason: stderr);
  expect(stderr, '');

  return process.stdout.toJointString();
}

extension on Stream<List<int>> {
  Future<String> toJointString() async {
    final list = await toList();
    final charCodes = list.expand((l) => l);
    return String.fromCharCodes(charCodes);
  }
}
