import 'dart:typed_data' show Uint8List;
import 'dart:convert' show Converter;
import 'dart:math' show log;

class Base62Encoder extends Converter<Uint8List, String> {
  const Base62Encoder(this.alphabet);

  final String alphabet;

  @override
  String convert(Uint8List input) {
    var zeroes = 0;
    var length = 0;
    var begin = 0;
    var end = input.length;
    while (begin != end && input[begin] == 0) {
      begin++;
      zeroes++;
    }

    var size = ((end - begin) * (log(256) / log(alphabet.length)) + 1).toInt();
    var b58 = Uint8List(size);

    while (begin != end) {
      var carry = input[begin];

      var i = 0;
      for (var it1 = size - 1;
          (carry != 0 || i < length) && (it1 != -1);
          it1--, i++) {
        carry += (256 * b58[it1]);
        b58[it1] = (carry % alphabet.length);
        carry = (carry ~/ alphabet.length);
      }
      if (carry != 0) {
        throw const FormatException('Non-zero carry');
      }
      length = i;
      begin++;
    }

    var it2 = size - length;
    while (it2 != size && b58[it2] == 0) {
      it2++;
    }

    var str = ''.padLeft(zeroes, alphabet[0]);
    for (; it2 < size; ++it2) {
      str += alphabet[b58[it2]];
    }
    return str;
  }
}
