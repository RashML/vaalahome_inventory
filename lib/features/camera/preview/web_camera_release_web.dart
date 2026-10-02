import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Stops every live camera track held by a `<video>` element on the page.
///
/// `mobile_scanner`'s web `stop()` drops its references to the MediaStream but
/// never calls `track.stop()`, so the browser keeps the camera on (the OS
/// camera indicator stays lit) until the page is closed. Flutter renders
/// platform views inside the `flt-glass-pane` shadow root, so both it and the
/// document are searched.
void releaseWebCameraTracks() {
  try {
    final document = globalContext['document'] as JSObject?;
    if (document == null) return;

    final roots = <JSObject>[document];
    final panes = document.callMethod<JSObject>(
      'querySelectorAll'.toJS,
      'flt-glass-pane'.toJS,
    );
    for (var i = 0; i < _length(panes); i++) {
      final shadow = panes.callMethod<JSObject?>('item'.toJS, i.toJS)
          ?.getProperty<JSObject?>('shadowRoot'.toJS);
      if (shadow != null) roots.add(shadow);
    }

    for (final root in roots) {
      final videos = root.callMethod<JSObject>('querySelectorAll'.toJS, 'video'.toJS);
      for (var i = 0; i < _length(videos); i++) {
        final video = videos.callMethod<JSObject>('item'.toJS, i.toJS);
        final stream = video.getProperty<JSObject?>('srcObject'.toJS);
        if (stream == null) continue;
        final tracks = stream.callMethod<JSArray<JSObject>>('getTracks'.toJS);
        for (final track in tracks.toDart) {
          track.callMethod<JSAny?>('stop'.toJS);
        }
        video.setProperty('srcObject'.toJS, null);
      }
    }
  } catch (_) {
    // Best effort: never let cleanup break navigation.
  }
}

int _length(JSObject list) => list.getProperty<JSNumber>('length'.toJS).toDartInt;
