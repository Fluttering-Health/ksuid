import 'package:ksuid/ksuid.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('generate/parse KSUID', () {
      final ksuid = KSUID.generate();
      final parsedKsuid = KSUID.parse(ksuid.asString);
      expect(ksuid, equals(parsedKsuid));
    });
    test('Parse KSUID', () {
      final ksuid = KSUID.parse('1HCpXwx2EK9oYluWbacgeCnFcLf');
      expect(ksuid.timestamp, equals(1550215977000));
      expect(
          ksuid.payload,
          equals([
            124,
            76,
            43,
            146,
            116,
            250,
            165,
            45,
            0,
            131,
            129,
            109,
            28,
            24,
            28,
            239
          ]));
      expect(ksuid.asRaw, equals('08f41d297c4c2b9274faa52d0083816d1c181cef'));
      expect(ksuid.asString, equals('1HCpXwx2EK9oYluWbacgeCnFcLf'));
      expect(ksuid.hexPayload, equals('7c4c2b9274faa52d0083816d1c181cef'));
    });
  });
}
