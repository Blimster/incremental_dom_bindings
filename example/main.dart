import 'dart:html';

import 'package:incremental_dom/incremental_dom.dart';

void main() {
  final root = querySelector('#root');

  void foo(e, n, v) => print('$e $n $v');

  attributes.setDefault(foo);

  patch(root, (data) {
    elementOpen(
      'div',
      null,
      [
        'style',
        {'color': 'red'},
      ],
    );
    text('hello world');
    elementClose('div');
  });
}
