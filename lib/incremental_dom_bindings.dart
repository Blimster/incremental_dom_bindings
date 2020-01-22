library incremental_dom;

import 'dart:html';
import 'dart:js';

final JsObject _incDom = context['IncrementalDOM'];
final JsObject _notifications = _incDom['notifications'];
final JsObject _attributes = _incDom['attributes'];

/// Maps a list arguments to be valid for Javascript
/// function call.
List<Object> _mapArgs(List<Object> args) {
  if (args == null) {
    return [];
  }
  return args.map((arg) {
    if (arg is Map) {
      return JsObject.jsify(arg);
    }
    return arg;
  }).toList();
}

/// Declares an Element with zero or more
/// attributes/properties that should be present at the
/// current location in the document tree.
///
/// The [tagname] is name of the tag, e.g. 'div' or 'span'.
/// This could also be the tag of a custom element.
///
/// A [key] identifies Element for reuse. See 'Keys and
/// Arrays' in the IncrementalDOM documentation.
///
/// [staticPropertyValuePairs] is a list of pairs of
/// property names and values. Depending on the type of the
/// value, these will be set as either attributes or
/// properties on the Element. These are only set on the
/// Element once during creation. These will not be updated
/// during subsequent passes. See 'Statics Array' in the
/// IncrementalDOM documentation.
///
/// [propertyValuePairs] is a list of pairs of property
/// names and values. Depending on the type of the value,
/// these will be set as either attributes or properties
/// on the Element.
///
/// Returns the corresponding DOM Element.
Element elementOpen(
  String tagname, [
  String key,
  List<Object> staticPropertyValuePairs,
  List<Object> propertyValuePairs,
]) {
  return _incDom.callMethod('elementOpen', [
    tagname,
    key,
    JsArray.from(_mapArgs(staticPropertyValuePairs)),
    ...?_mapArgs(propertyValuePairs),
  ]);
}

/// Used with [attr] and [elementOpenEnd] to declare an
/// element.
///
/// The [tagname] is name of the tag, e.g. 'div' or 'span'.
/// This could also be the tag of a custom element.
///
/// A [key] identifies Element for reuse. See 'Keys and
/// Arrays' in the IncrementalDOM documentation.
///
/// [staticPropertyValuePairs] is a list of pairs of
/// property names and values. Depending on the type of the
/// value, these will be set as either attributes or
/// properties on the Element. These are only set on the
/// Element once during creation. These will not be updated
/// during subsequent passes. See 'Statics Array' in the
/// IncrementalDOM documentation.
void elementOpenStart(
  String tagname, [
  String key,
  List<Object> staticPropertyValuePairs,
]) {
  final args = [
    tagname,
    key,
    JsArray.from(_mapArgs(staticPropertyValuePairs)),
  ];
  _incDom.callMethod('elementOpenStart', args);
}

/// Used with [elementOpenStart] and [elementOpenEnd] to declare an element.
///
/// Sets an attribute with [name] and [value].
void attr(String name, Object value) => _incDom.callMethod('attr', [name, value]);

/// Used with [elementOpenStart] and [attr] to declare an
/// element.
///
/// Returns the corresponding DOM Element.
Element elementOpenEnd() => _incDom.callMethod('elementOpenEnd');

/// Signifies the end of the element opened with
/// [elementOpen], corresponding to a closing tag (e.g.
/// </div> in HTML). Any childNodes of the currently open
/// Element that are in the DOM that have not been
/// encountered in the current render pass are removed by
/// the call to [elementClose].
///
/// The [tagname] is name of the tag, e.g. 'div' or 'span'.
/// This could also be the tag of a custom element.
///
/// Returns the corresponding DOM Element.
Element elementClose(String tagname) => _incDom.callMethod('elementClose', [tagname]);

/// A combination of [elementOpen], followed by
/// [elementClose].
///
/// The [tagname] is name of the tag, e.g. 'div' or 'span'.
/// This could also be the tag of a custom element.
///
/// A [key] identifies Element for reuse. See 'Keys and
/// Arrays' in the IncrementalDOM documentation.
///
/// [staticPropertyValuePairs] is a list of pairs of
/// property names and values. Depending on the type of the
/// value, these will be set as either attributes or
/// properties on the Element. These are only set on the
/// Element once during creation. These will not be updated
/// during subsequent passes. See 'Statics Array' in the
/// IncrementalDOM documentation.
///
/// [propertyValuePairs] is a list of pairs of property
/// names and values. Depending on the type of the value,
/// these will be set as either attributes or properties
/// on the Element.
///
/// Returns the corresponding DOM Element.
Element elementVoid(
  String tagname, [
  String key,
  List<Object> staticPropertyValuePairs,
  List<Object> propertyValuePairs,
]) {
  return _incDom.callMethod('elementVoid', [
    tagname,
    key,
    JsArray.from(_mapArgs(staticPropertyValuePairs)),
    ...?_mapArgs(propertyValuePairs),
  ]);
}

/// Declares a Text node, with the specified [text], should
/// appear at the current location in the document tree.
///
/// The [formatters] are optional functions that format the
/// value when it changes. The formatters are applied in the
/// order they appear in the lost of formatters. The second
/// formatter will receive the result of the first formatter
/// and so on.
///
/// Returns the corresponding DOM Text Node.
Text text(Object value, {List<String Function(Object)> formatters}) {
  return _incDom.callMethod('text', [
    value,
    ...?formatters,
  ]);
}

/// Updates the provided Node with a function containing
/// zero or more calls to [elementOpen], [text] and
/// [elementClose]. The provided callback function may call
/// other such functions. The [patch] function may be
/// called with a new Node while a call to [patch] is
/// already executing.
///
/// This function patches the [node]. Typically, this
/// will be an HTMLElement or DocumentFragment.
///
/// [description] is the callback to build the DOM tree
/// underneath [node].
void patch(Node node, void Function(Object) description, [Object data]) {
  _incDom.callMethod('patch', [node, description, data]);
}

/// Provides a way to get the currently open element.
///
/// Returns the currently open element.
Element currentElement() => _incDom.callMethod('currentElement');

/// The current location in the DOM that Incremental DOM is
/// looking at. This will be the next Node that will be
/// compared against for the next [elementOpen] or text
/// call.
///
/// Returns the next node that will be compared.
Node currentPointer() => _incDom.callMethod('currentPointer');

/// Moves the current pointer to the end of the currently
/// open element. This prevents Incremental DOM from
/// removing any children of the currently open element.
/// When calling skip, there should be no calls to
/// [elementOpen] (or similiar) prior to the [elementClose]
/// call for the currently open element.
void skip() => _incDom.callMethod('skip');

/// Moves the current patch pointer forward by one node.
/// This can be used to skip over elements declared outside
/// of Incremental DOM.
void skipNode() => _incDom.callMethod('skipNode');

/// A function to set a value as a property
/// or attribute for an element.
typedef ValueSetter = void Function(Element element, String name, Object value);

/// A predefined function, that applies a value as a
/// property.
ValueSetter get applyProp {
  return (Element element, String name, Object value) => _incDom['applyProp'].apply([element, name, value]);
}

/// A predefined function, that applies a value as an
/// attribute.
ValueSetter get applyAttr {
  return (Element element, String name, Object value) => _incDom['applyAttr'].apply([element, name, value]);
}

/// See [attributes].
class Attributes {
  Attributes._();

  /// If no function is specified for a given name, a
  /// default function is used that applies values as
  /// described in Attributes and Properties. This can
  /// be changed by specifying the default function.
  ///
  /// FIXME: not yet working
  void setDefault(ValueSetter setter) {
    this['__default'] = setter;
  }

  /// Sets a [ValueSetter] for a property/attribute
  /// identified by a [name].
  void operator []=(String name, ValueSetter setter) {
    _attributes[name] = setter;
  }
}

/// The [attributes] object allows you to provide a
/// function to decide what to do when an attribute
/// passed to elementOpen or similar functions changes.
/// The following example makes IncrementalDOM always
/// set value as a property.
///
/// ```
/// attributes['value'] = applyProp;
/// ```
final attributes = Attributes._();

/// A listener for node events.
typedef NodeListener = void Function(List<Node> nodes);

/// See [notifications].
class Notifications {
  /// Sets the listener for the event of added nodes.
  set nodesCreaded(NodeListener listener) =>
      _notifications['nodesCreated'] = (JsArray nodes) => listener(nodes.cast<Node>().toList());

  /// Sets the listener for the event of deleted nodes.
  set nodesDeleted(NodeListener listener) =>
      _notifications['nodesDeleted'] = (JsArray nodes) => listener(nodes.cast<Node>().toList());
}

/// You can be notified when Nodes are added or removed by
/// IncrementalDOM by specifying functions for
/// [notifications.nodesCreated] and
/// [notifications.nodesDeleted]. If there are added or
/// removed nodes during a patch operation, the appropriate
/// function will be called at the end of the patch with
/// the added or removed nodes.
final notifications = Notifications();
