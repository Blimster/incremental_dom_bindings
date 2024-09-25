# incremental_dom_bindings
Dart binding for the Incremental DOM library.

From the original Incremental DOM documentation:
>Incremental DOM is a library for expressing and applying updates to DOM trees. JavaScript can be used to extract, iterate over and transform data into calls generating HTMLElements and Text nodes. It differs from Virtual DOM approaches in that a diff operation is performed incrementally (that is one node at a time) against the DOM, rather than on a virtual DOM tree.
>
>Rather than targeting direct usage, Incremental DOM aims to provide a platform for higher level libraries or frameworks. As you might notice from the examples, Incremental DOM-style markup can be somewhat challenging to write and read. See [Why Incremental DOM](http://google.github.io/incremental-dom/#why-incremental-dom) for an explanation.

## Usage
For detailed documentation see [http://google.github.io/incremental-dom/](http://google.github.io/incremental-dom/).

This package requires the Incremental DOM Javascript library to be loaded. Add
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

import 'package:incremental_dom_bindings/incremental_dom_bindings.dart';

void main() {
  // Get an existing HTML element. Its content will be changed.
  final root = querySelector('#root')!;

  // Patch the element.
  patch(root, (_) {
    // Open a div element with the attributes id and style.
    elementOpen('div', null, [
      'id',
      'testId',
      'style',
      {'color': 'red'}
    ]);

    // Add text inside the div element.
    text('Hello World');

    // Add </div>.
    elementClose('div');
  });
}
```

## Commentary

As you can see, Incremental DOM allows you to create a template language or a declarative DOM layer, using its imperative style gradual (incremental) building of a DOM tree. It does not build a virtual DOM tree; instead, as the imperative code gets called, the real DOM tree is diffed and modified immediately. This saves RAM and garbage collection, compared to a virtual DOM approach.

It is not a complete reactive library: it knows how to patch the DOM from that imperative code. The user library would provide a declarative layer and know *when* to call `patch()`.

## 2 optimizations in the API

The 2nd argument to `elementOpen()` is a key. It is supposed to be used only in loops, as an optimization. If you have a list of entities you are showing on the page, you would inform the unique ID of each entity as the 2nd argument. Since Incremental DOM works gradually, it probably does not see the entire incoming DOM tree at once. So I suppose it uses the keys to understand when an item has been added or deleted from the list.

Incremental DOM also separates static attributes from dynamic ones. You actually inform static and dynamic attributes in separate arguments to its functions. This is another optimization: if an attribute never changes, you can have the library not bother comparing it.

