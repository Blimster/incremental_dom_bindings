@TestOn('browser')

import 'dart:html';

import 'package:incremental_dom_bindings/incremental_dom_bindings.dart';
import 'package:test/test.dart';

void main() {
  late Element root;

  setUp(() {
    root = querySelector('#root')!;
    root.children.clear();
  });

  group('elementOpen()', () {
    test('creates an elemement in the DOM that is equal to the one returned by the function call', () {
      late Element elementFromCall;
      patch(root, (_) {
        elementFromCall = elementOpen('span');
        elementClose('span');
      });

      final elementFromDom = root.children.first;
      expect(elementFromDom.tagName, equalsIgnoringCase('span'));
      expect(elementFromDom, equals(elementFromCall));
    });
    test('creates an element with the given attributes and properties', () {
      patch(root, (Object _) {
        final element = elementOpen('span', null, ['class', 'testClass', 'onclick', (Object _) {}], ['id', 'testId']);
        elementClose('span');

        expect(element.attributes['class'], equals('testClass'));
        expect(element.attributes['id'], equals('testId'));
        expect(element.onClick, isNotNull);
      });
    });
  });

  group('elementOpenStart()', () {
    test('creates an element in the DOM that is equal to the one returned by the function call', () {
      patch(root, (_) {
        elementOpenStart('span');
        final elementFromCall = elementOpenEnd();
        elementClose('span');

        final elementFromDom = root.children.first;
        expect(elementFromDom.tagName, equalsIgnoringCase('span'));
        expect(elementFromDom, equals(elementFromCall));
      });
    });

    test('creates an element with the given attributes and properties', () {
      patch(root, (_) {
        elementOpenStart('span', null, ['id', 'testId', 'class', 'testClass', 'onclick', (Object _) {}]);
        final element = elementOpenEnd();
        elementClose('span');

        expect(element.attributes['id'], equals('testId'));
        expect(element.attributes['class'], equals('testClass'));
        expect(element.onClick, isNotNull);
      });
    });
  });

  group('attr()', () {
    test('adds attributes to an element', () {
      patch(root, (_) {
        elementOpenStart('span');
        attr('id', 'testId');
        attr('onclick', () {});
        final element = elementOpenEnd();
        elementClose('span');

        expect(element.attributes['id'], equals('testId'));
        expect(element.onClick, isNotNull);
      });
    });
  });

  group('elementOpenEnd()', () {
    test('returns the element added to the DOM', () {
      patch(root, (_) {
        elementOpenStart('span');
        final elementFromCall = elementOpenEnd();
        elementClose('span');

        final elementFromDom = root.children.first;
        expect(elementFromDom.tagName, equalsIgnoringCase('span'));
        expect(elementFromDom, equals(elementFromCall));
      });
    });
  });

  group('elementClose()', () {
    test('returns the element added to the DOM', () {
      patch(root, (_) {
        elementOpenStart('span');
        elementOpenEnd();
        final elementFromCall = elementClose('span');

        final elementFromDom = root.children.first;
        expect(elementFromDom.tagName, equalsIgnoringCase('span'));
        expect(elementFromDom, equals(elementFromCall));
      });
    });
  });

  group('elementVoid()', () {
    test('creates an elemement in the DOM that is equal to the one returned by the function call', () {
      patch(root, (_) {
        final elementFromCall = elementVoid('span');

        final elementFromDom = root.children.first;
        expect(elementFromDom.tagName, equalsIgnoringCase('span'));
        expect(elementFromDom, equals(elementFromCall));
      });
    });
    test('creates an element with the given attributes and properties', () {
      patch(root, (_) {
        final element = elementVoid('span', null, ['class', 'testClass', 'onclick', (Object _) {}], ['id', 'testId']);

        expect(element.attributes['class'], equals('testClass'));
        expect(element.attributes['id'], equals('testId'));
        expect(element.onClick, isNotNull);
      });
    });
  });

  group('text()', () {
    test('adds a text to the DOM', () {
      patch(root, (_) {
        elementOpen('span');
        text('testText');
        elementClose('spam');

        final elementFromDom = root.children.first;
        expect(elementFromDom.text, equalsIgnoringCase('testText'));
      });
    });

    test('applies formatters', () {
      patch(root, (_) {
        final element = elementOpen('span');
        text('testText', formatters: [(v) => v.toString().toLowerCase(), (v) => v.toString().replaceFirst('e', '3')]);
        elementClose('spam');

        expect(element.text, equalsIgnoringCase('t3sttext'));
      });
    });
  });

  group('patch', () {
    test('modifies the DOM beneath an element', () {
      patch(root, (_) {
        elementVoid('span');
        expect(root.children.length, equals(1));
      });
    });

    test('provides parameter "data" to the description function', () {
      patch(root, (data) {
        expect(data, equals('data'));
      }, 'data');
    });

    test('can be used recursively', () {
      patch(root, (_) {
        final span = elementVoid('span');
        patch(span, (_) {
          elementVoid('div');

          expect(root.children.length, equals(1));
          expect(root.children[0].children.length, equals(1));
          expect(root.children[0].children[0].tagName, 'DIV');
        });
      });
    });
  });

  group('currentElement()', () {
    test('returns the current element', () {
      patch(root, (_) {
        final element = elementOpen('span');
        expect(currentElement(), equals(element));
        elementClose('span');
      });
    });
  });

  group('currentPointer()', () {
    test('returns the pointer to the next node', () {
      // add 2 elements to the DOM
      patch(root, (_) {
        elementVoid('div');
        elementVoid('span');
      });

      // add 1 element and verify, that the pointer returns the second element
      patch(root, (_) {
        elementVoid('div');
        final node = currentPointer();
        expect(node, isA<Element>());
        expect((node as Element).tagName, equals('SPAN'));
      });
    });
  });

  group('skip()', () {
    test('returns the pointer to the next node', () {
      // add 2 nested elements to the DOM
      patch(root, (_) {
        elementOpen('div');
        elementVoid('span');
        elementClose('div');
      });

      // add 1 element and skip the nested element.
      patch(root, (_) {
        elementOpen('div');
        skip();
        elementClose('div');

        expect(root.children.length, equals(1));
        // the nested one should still be in the DOM
        expect(root.children[0].children.length, equals(1));
      });
    });
  });

  group('skipNode()', () {
    test('skips a node in DOM (does not remove it)', () {
      // add 3 elements to the DOM
      patch(root, (_) {
        elementVoid('div');
        elementVoid('span');
        elementVoid('h1');
      });

      patch(root, (_) {
        elementVoid('div');
        skipNode();
        elementVoid('div');
      });

      // all 3 element should still be in the DOM
      expect(root.children.length, equals(3));
    });
  });

  group('attributes', () {
    test('calls value setter for an specific attribute', () {
      var counter = 0;
      late Element element;
      late String name;
      late Object? value;
      attributes['class'] = (e, n, v) {
        counter++;
        element = e;
        name = n;
        value = v;
      };

      late Element elementFromCall;
      patch(root, (_) {
        elementFromCall = elementVoid('span', null, ['class', 'testClass', 'id', 'testId']);
      });

      expect(counter, equals(1));
      expect(element, equals(elementFromCall));
      expect(name, equals('class'));
      expect(value, equals('testClass'));

      // remove attribute-specific value setter
      attributes['class'] = null;
    });

    test('calls the default value setter', () {
      var counter = 0;
      late Element element;
      late String name;
      late Object? value;
      attributes.setDefault((e, n, v) {
        counter++;
        element = e;
        name = n;
        value = v;
      });

      late Element elementFromCall;
      patch(root, (_) {
        elementFromCall = elementVoid('span', null, ['class', 'testClass', 'id', 'testId']);
      });

      expect(counter, equals(2));
      expect(element, equals(elementFromCall));
      expect(name, equals('id'));
      expect(value, equals('testId'));

      attributes.setDefault(null);
    });
  });

  group('notifications', () {
    test('calls listener for add/remove events', () {
      final created = <Node>[];
      final deleted = <Node>[];
      notifications.nodesCreaded = (nodes) => created.addAll(nodes);
      notifications.nodesDeleted = (nodes) => deleted.addAll(nodes);

      patch(root, (_) {
        elementVoid('div');
        elementVoid('span');
      });
      expect(created.length, equals(2));
      expect(created.map((n) => (n as Element).tagName), containsAllInOrder(<String>['DIV', 'SPAN']));
      expect(deleted.length, equals(0));

      created.clear();
      patch(root, (_) {});
      expect(deleted.length, equals(2));
      expect(deleted.map((n) => (n as Element).tagName), containsAllInOrder(<String>['SPAN', 'DIV']));
      expect(created.length, equals(0));
    });
  });
}
