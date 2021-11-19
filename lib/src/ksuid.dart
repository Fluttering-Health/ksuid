import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ksuid/src/base62/base62_codec.dart';
import 'package:ksuid/src/utils/collections.dart';

final _random = Random.secure();

class KSUID {
  static const int kEPOCH = 1400000000;
  static const int kPayloadBytes = 16;

  static const int kTimestampBytes = 4;
  static const int kTotalBytes = kTimestampBytes + kPayloadBytes;
  static const int kPadToLength = 27;

  late final int _timestamp;
  late final Uint8List _payload;
  late final Uint8List _bytes;

  static _defaultSupplier() => Uint8List.fromList(
        List<int>.generate(
          KSUID.kPayloadBytes,
          (i) => _random.nextInt(256),
        ),
      );

  KSUID._({Uint8List? bytes, Uint8List? payload, int? timestamp})
      : assert(bytes != null || (timestamp != null && payload != null)) {
    if (bytes != null) {
      if (bytes.length != kTotalBytes) {
        throw Exception("KSUID is not expected length of $kTotalBytes bytes");
      }

      _bytes = bytes;
      final buffer = _bytes.buffer;
      _timestamp = buffer.asByteData().getInt32(0);
      _payload = buffer.asUint8List(kTimestampBytes);
    } else {
      if (payload?.length != kPayloadBytes) {
        throw Exception(
            "Payload is not expected length of $kPayloadBytes bytes");
      }

      _timestamp = timestamp!;
      _payload = payload!;

      final timestampByteData = ByteData(kTimestampBytes)
        ..setInt32(0, _timestamp);
      final bytesBuilder = BytesBuilder()
        ..add(timestampByteData.buffer.asUint8List())
        ..add(_payload);

      _bytes = bytesBuilder.toBytes();
    }
  }

  factory KSUID.buffer(Uint8List buffer) {
    if (buffer.length != KSUID.kTotalBytes) {
      throw Exception(
        "Buffer is not expected length of $kTotalBytes bytes",
      );
    }
    return KSUID._(bytes: buffer);
  }

  factory KSUID.parse(String ksuid) => KSUID._(bytes: base62Decode(ksuid));

  factory KSUID.generate({DateTime? date, Uint8List? payload}) {
    if (payload != null && payload.length != KSUID.kPayloadBytes) {
      throw Exception(
        "Payload is not expected length of $kPayloadBytes bytes",
      );
    }
    final timestamp =
        ((date ?? DateTime.now()).millisecondsSinceEpoch / 1000 - KSUID.kEPOCH)
            .toInt();
    return KSUID._(
      timestamp: timestamp,
      payload: payload ?? _defaultSupplier(),
    );
  }

  static bool isValid(Uint8List buffer) => buffer.length == kTotalBytes;

  Uint8List get payload => Uint8List.fromList(_payload);

  Uint8List get asBytes => Uint8List.fromList(_bytes);

  String get asString => base62Encode(_bytes);

  String get asRaw => hex.encode(_bytes);

  DateTime get date =>
      DateTime.fromMillisecondsSinceEpoch((_timestamp + kEPOCH) * 1000);

  int get timestamp => (_timestamp + kEPOCH) * 1000;

  String get hexPayload => hex.encode(_payload);

  int compareTo(KSUID other) => _timestamp - other._timestamp;

  String get asInspectString => 'REPRESENTATION:\n\n'
      '  String: $asString\n'
      '     Raw: $asRaw\n\n'
      'COMPONENTS:\n\n'
      '       Time: $date\n'
      '  Timestamp: $timestamp\n'
      '    Payload: $hexPayload\n';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KSUID &&
          runtimeType == other.runtimeType &&
          _timestamp == other._timestamp &&
          listEquals(_payload, other._payload) &&
          listEquals(_bytes, other._bytes);

  @override
  int get hashCode => _timestamp.hashCode ^ _payload.hashCode ^ _bytes.hashCode;

  @override
  String toString() =>
      'KSUID{\n Timestamp: $_timestamp,\n Payload: $_payload,\n Bytes: $_bytes\n}';
}
