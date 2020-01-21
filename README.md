# incremental_dom
Dart binding for the Incremental DOM library.

From the original Incremental DOM docuementation:
>Incremental DOM is a library for expressing and applying updates to DOM trees. JavaScript can be used to extract, iterate over and transform data into calls generating HTMLElements and Text nodes. It differs from Virtual DOM approaches in that a diff operation is performed incrementally (that is one node at a time) against the DOM, rather than on a virtual DOM tree.
>
>Rather than targeting direct usage, Incremental DOM aims to provide a platform for higher level libraries or frameworks. As you might notice from the examples, Incremental DOM-style markup can be somewhat challenging to write and read. See [Why Incremental DOM](http://google.github.io/incremental-dom/#why-incremental-dom) for an explanation.

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
to your `index.html`.

## Example
This simple example adds an element to the DOM.
```dart
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
```
