[![Pub Package](https://img.shields.io/pub/v/show_augmentation.svg)](https://pub.dev/packages/show_augmentation)
[![GitHub](https://img.shields.io/github/license/alexeyinkin/dart-show-augmentation)](https://github.com/alexeyinkin/dart-show-augmentation/blob/main/LICENSE)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/alexeyinkin/dart-show-augmentation?style=flat-square)](https://www.codefactor.io/repository/github/alexeyinkin/dart-show-augmentation)
[![Support Chat](https://img.shields.io/badge/support%20chat-telegram-brightgreen)](https://ainkin.com/chat)

This tool shows augmentation generated by [Dart macros](https://dart.dev/language/macros).

You can usually view it in your IDE:

![VSCode](https://raw.githubusercontent.com/alexeyinkin/dart-show-augmentation/main/img/vscode.png)

But currently only VSCode supports it. It's experimental and sometimes buggy.
If the IDE does not work for you, use this tool.

## Usage

1. [Switch to Dart 3.5+](https://dart.dev/language/macros#set-up-the-experiment) (currently experimental).

2. Make sure Dart 3.5+ is in your `$PATH` before any stable Dart location.

3. Add this package as dev_dependency to pubspec.yaml:

```yaml
dev_dependency:
  show_augmentation: ^0.1.0-1.dev
```

4. Run `dart pub get`

5. Run in the command line:

```bash
dart run show_augmentation --file=relative/path/to/file.dart
```

It will print the augmentation for the file if it has macro applications.
It will print nothing otherwise.


## Example

This package comes with an example file and macro.
For this example, run:

```bash
cd example
dart run show_augmentation --file=lib/hello_client.dart
```

The output:

```dart
augment library 'package:show_augmentation_example/hello_client.dart';

import 'dart:core' as prefix0;

augment class User {
void hello() {prefix0.print('Hello! I am User. I have age, name, username.');}
}
```


## How it Works

Most of the tips and navigation in most IDEs come not from the IDE but from Dart itself.
Modern IDEs do not interpret the code themselves.
Instead, Dart and most other languages now have so-called *language servers* shipped with them.
An IDE starts such a server locally for a given language and tells it to analyze the entire project
and tell it any intel for a given file that the user is currently viewing: errors, warnings,
fix suggestions, "Go to Definition", etc.
[Language Server Protocol](https://microsoft.github.io/language-server-protocol/)
is used for communication between an IDE and servers,
it's standard for all languages.

Viewing the augmentation in Dart works the same way.
An IDE asks the Dart language server to show augmentation for a given file.
It works one way, and that's why the augmentation in VSCode is read-only.

This tool does the same. It launches the Dart language server locally,
tells it to analyze your project, and then requests the augmentation for the given file.
That's why the result is the same as with viewing it in your IDE.

This tool uses my package [lsp_client](https://pub.dev/packages/lsp_client) for this communication.