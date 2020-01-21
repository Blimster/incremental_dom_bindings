# incremental_dom
Dart binding for the Incremental DOM library.

## Usage
For a detailed documentation see [http://google.github.io/incremental-dom/](http://google.github.io/incremental-dom/).

This packages requires the Incremental DOM Javascript library to be loaded. Add
```html
<script src="/packages/incremental_dom/assets/incremental-dom.js"></script>
```
or 
```html
<script src="/packages/incremental_dom/assets/incremental-dom-min.js"></script>
```
to the `index.html`.

## Example
This simple example adds an element to the DOM.
```dart
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
```
