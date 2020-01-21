import 'dart:html';

import 'package:incremental_dom/incremental_dom.dart';

void main() {
  // query the element to patch
  final root = querySelector('#root');

  // patch the element
  patch(root, (_) {
    // open a div element with the attributes id and style
    elementOpen('div', null, [
      'id',
      'testId',
      'style',
      {'color': 'red'}
    ]);

    // add a text inside the div element
    text('Hello World');

    // close the div element
    elementClose('div');
  });
}
