import 'dart:html';

import 'package:incremental_dom/incremental_dom.dart';

void main() {
  final root = querySelector('#root');

  patch(root, (data) {
    elementOpen('div', null, [
      'id',
      'testId',
      'style',
      {'color': 'red'}
    ]);
    text('Hello World');
    elementClose('div');
  });
}
