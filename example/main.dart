import 'dart:html';

import 'package:incremental_dom/incremental_dom.dart';

void main() {
  final root = querySelector('#root');

  patch(root, (data) {
    final foo = elementOpen(
      'div',
      null,
      [
        'class',
        'testClass',
        'style',
        {'color': 'red'},
      ],
    );
    text('hello world');
    elementClose('div');

    print(foo.attributes['class']);
  });
}
