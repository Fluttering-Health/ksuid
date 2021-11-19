# ksuid

A Dart implementation of [Segment's KSUID library](https://github.com/segmentio/ksuid).

You may also be interested in [`ksuid-cli`](https://www.npmjs.com/package/ksuid-cli).

## Installation

```js
dependencies:
  ksuid: 1.0.0
```

### Creation

You can create a new instance:

```js
final ksuid = KSUID.generate();
```

You can also specify a specific time as a `Date` object:

```js
final ksuidFromDate = KSUID.generate(date: DateTime.parse("2014-05-25T16:53:20Z"));
```

Or you can compose it using a timestamp and a 16-byte payload:

```js
final date = DateTime.now();
final payload = Uint8List(16);
final yesterdayKSUID = KSUID.generate(date: date, payload: payload);
```

You can parse a valid string-encoded KSUID:

```js
final parsedKSUID = KSUID.parse('aWgEPTl1tmebfsQzFP4bxwgy80V');
```

Finally, you can create a KSUID from a 20-byte buffer:

```js
const fromBuffer = KSUID.buffer(buffer)
```

### Properties

Once the KSUID has been created, use it:

```js
final ksuid = KSUID.generate();
ksuid.asString; // The KSUID encoded as a fixed-length string
ksuid.asRaw; // The KSUID as a 20-byte buffer
ksuid.date; // The timestamp portion of the KSUID, as a `Date` object
ksuidc.timestamp; // The raw timestamp portion of the KSUID, as a number
ksuid.payload; // A Buffer containing the 16-byte payload of the KSUID (typically a random value)
```

### Comparisons

You can compare KSUIDs:

```js
todayKSUID.compareTo(yesterdayKSUID) // 1
todayKSUID.compareTo(todayKSUID) // 0
yesterdayKSUID.compareTo(todayKSUID) // -1
```

And check for equality:

```js
previousKSUID == nextKSUID
```

### Validation

You can check whether a particular buffer is a valid KSUID:

```js
KSUID.isValid(buffer) // Boolean
```