import 'dart:typed_data' show Uint8List;
import 'dart:convert' show Codec;

import 'package:ksuid/src/base62/base62_decoder.dart';
import 'package:ksuid/src/base62/base62_encoder.dart';

class Base62Codec extends Codec<Uint8List, String> {
  static const alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  @override
  late final Base62Encoder encoder = const Base62Encoder(alphabet);

  @override
  late final Base62Decoder decoder = Base62Decoder(alphabet);
}

final Base62Codec base62 = Base62Codec();

Uint8List base62Decode(String source) => base62.decode(source);

String base62Encode(Uint8List bytes) => base62.encode(bytes);
