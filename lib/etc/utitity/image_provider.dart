import 'dart:io';

import 'package:flutter/widgets.dart';

/// Get [ImageProvider] from URI provided,
/// Null if failed to parse or URI==null
ImageProvider? getImageProviderFromUri(String? uri) {
  if (uri == null) {
    return null;
  }
  if (uri.startsWith('http')) {
    return NetworkImage(uri);
  } else if (uri.startsWith('file') || uri.startsWith('/')) {
    return FileImage(File(Uri.decodeFull(uri).replaceFirst('file://', '')));
  } else {
    return null;
  }
}
