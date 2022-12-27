import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Widget keyboardKey(String text, Function method, [bool accent = false]) {
  return Expanded(
    flex: 1,
    child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: accent
                ? BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  )
                : null,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              highlightColor: accent ? Colors.blue : null,
              onTap: () {
                HapticFeedback.lightImpact();
                method();
              },
              child: Center(
                  child: text == "<-"
                      ? const Icon(
                          Icons.backspace_rounded,
                          size: 25,
                        )
                      : Text(text,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ))),
            ),
          ),
        )),
  );
}

// function from https://medium.com/flutter-community/custom-in-app-keyboard-in-flutter-b925d56c8465
void _backspace(TextEditingController controller) {
  final text = controller.text;
  final textSelection = controller.selection;
  final selectionLength = textSelection.end - textSelection.start;
  // There is a selection.
  if (selectionLength > 0) {
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      '',
    );
    controller.text = newText;
    controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start,
      extentOffset: textSelection.start,
    );
    return;
  }
  // The cursor is at the beginning.
  if (textSelection.start == 0) {
    return;
  }
  // Delete the previous character
  const offset = 1;
  final newStart = textSelection.start - offset;
  final newEnd = textSelection.start;
  final newText = text.replaceRange(
    newStart,
    newEnd,
    '',
  );
  controller.text = newText;
  controller.selection = textSelection.copyWith(
    baseOffset: newStart,
    extentOffset: newStart,
  );
}

void _insertText(
    String input, TextEditingController editingController, bool replace) {
  final text = editingController.text;
  TextSelection textSelection = editingController.selection;
  if ((textSelection.start == -1 && textSelection.end == -1) || replace) {
    textSelection = textSelection.copyWith(baseOffset: 0, extentOffset: 0);
  }
  String newText = "";
  if (replace) {
    newText = input;
  } else {
    newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      input,
    );
  }
  final textLength = input.length;
  editingController.text = newText;
  editingController.selection = textSelection.copyWith(
    baseOffset: textSelection.start + textLength,
    extentOffset: textSelection.start + textLength,
  );
}

void editText(
    String key, int textLimit, TextEditingController editingController) {
  switch (key) {
    case "1":
    case "2":
    case "3":
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
    case "0":
      if (editingController.text.isEmpty && key == "0") {
        break;
      }

      if (editingController.text.length < textLimit) {
        _insertText(key, editingController, false);
      }
      break;
    case ".":
      if (editingController.text.length < textLimit &&
          !editingController.text.contains(".")) {
        if (editingController.text.isEmpty) {
          _insertText("0", editingController, false);
        }
        _insertText(key, editingController, false);
      }
      break;
    case "<-":
      if (editingController.text.isNotEmpty) _backspace(editingController);
      if (editingController.text == "0") _backspace(editingController);
      break;
  }
}

Widget customKeyboard(TextEditingController editingController, int textLimit,
    [Function? method]) {
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
    height: 340.0,
    width: 320,
    child: Column(
      children: [
        Expanded(
          child: Row(children: [
            keyboardKey('1', () {
              editText("1", textLimit, editingController);
            }),
            keyboardKey('2', () {
              editText("2", textLimit, editingController);
            }),
            keyboardKey('3', () {
              editText("3", textLimit, editingController);
            }),
          ]),
        ),
        Expanded(
          child: Row(children: [
            keyboardKey('4', () {
              editText("4", textLimit, editingController);
            }),
            keyboardKey('5', () {
              editText("5", textLimit, editingController);
            }),
            keyboardKey('6', () {
              editText("6", textLimit, editingController);
            }),
          ]),
        ),
        Expanded(
          child: Row(children: [
            keyboardKey('7', () {
              editText("7", textLimit, editingController);
            }),
            keyboardKey('8', () {
              editText("8", textLimit, editingController);
            }),
            keyboardKey('9', () {
              editText("9", textLimit, editingController);
            }),
          ]),
        ),
        Expanded(
          child: Row(children: [
            keyboardKey('.', () {
              editText(".", textLimit, editingController);
            }),
            keyboardKey('0', () {
              editText("0", textLimit, editingController);
            }),
            keyboardKey('<-', () {
              editText("<-", textLimit, editingController);
            }, true),
          ]),
        ),
      ],
    ),
  );
}
