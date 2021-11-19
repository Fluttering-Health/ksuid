import 'dart:typed_data';

import 'package:ksuid/ksuid.dart';

void main() {
  // create a new instance
  final ksuid = KSUID.generate();

  // You can also specify a specific time as a Date object:
  final ksuidFromDate = KSUID.generate(date: DateTime.parse("2014-05-25T16:53:20Z"));
  print(ksuidFromDate);

  // Or you can compose it using a timestamp and a 16-byte payload:
  final date = DateTime.now();
  final payload = Uint8List(KSUID.kPayloadBytes);
  final yesterdayKSUID = KSUID.generate(date: date, payload: payload);
  print(yesterdayKSUID);

  //You can parse a valid string-encoded KSUID:
  final parsedKSUID = KSUID.parse('aWgEPTl1tmebfsQzFP4bxwgy80V');
  print(parsedKSUID);

  final buffer = Uint8List(KSUID.kTotalBytes);
  final fromBuffer = KSUID.buffer(buffer);
  print(fromBuffer);

  // Once the KSUID has been created, use it:
  ksuid.asString; // The KSUID encoded as a fixed-length string
  ksuid.asRaw; // The KSUID as a 20-byte buffer
  ksuid.date; // The timestamp portion of the KSUID, as a `Date` object
  ksuid.timestamp; // The raw timestamp portion of the KSUID, as a number
  ksuid.payload; // A Buffer containing the 16-byte payload of the KSUID (typically a random value)
}
