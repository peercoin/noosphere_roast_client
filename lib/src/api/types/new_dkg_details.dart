import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';
import 'expiry.dart';
import 'signed.dart';

/// Details of DKG requested by a participant. This is signed by the participant
/// and sent to the other participants.
class NewDkgDetails with cl.Writable, Signable {

  static int minNameLength = 3;
  static int maxNameLength = 40;
  static int maxDescLength = 1000;

  /// A unique name for the DKG between 3-40 characters
  final String name;
  /// A more in-depth description of the DKG up-to 1000 characters
  final String description;
  /// The threshold for the desired key
  final int threshold;
  /// The requested expiry of the DKG
  final Expiry expiry;

  NewDkgDetails._({
    required this.name,
    required this.description,
    required this.threshold,
    required this.expiry,
    bool allowNegativeExpiry = false,
  }) {
    if (name.length < minNameLength || name.length > maxNameLength) {
      throw ArgumentError.value(name, "name");
    }
    if (description.length > maxDescLength) {
      throw ArgumentError.value(name, "description");
    }
    if (threshold < 2 || threshold > 0xffff) {
      throw ArgumentError.value(threshold, "threshold");
    }
    if (!allowNegativeExpiry) {
      expiry.requireNotExpired();
    }
  }

  /// The [name] must be unique and the [description] should explain what the
  /// key is to be used for. The name must be within 40 characters and the
  /// description must be within 1,000 characters.
  ///
  /// The [threshold] should be within the group participant size minus one.
  ///
  /// The [expiry] is the maximum time after which the request will expire.
  /// The DKG must be completed by this time.
  NewDkgDetails({
    required String name,
    required String description,
    required int threshold,
    required Expiry expiry,
  }) : this._(
    name: name, description: description, threshold: threshold, expiry: expiry,
  );

  /// Should only be used in tests
  NewDkgDetails.allowNegativeExpiry({
    required String name,
    required String description,
    required int threshold,
    required Expiry expiry,
  }) : this._(
    name: name, description: description, threshold: threshold, expiry: expiry,
    allowNegativeExpiry: true,
  );

  NewDkgDetails.fromReader(cl.BytesReader reader) : this(
    name: reader.readString(),
    description: reader.readString(),
    threshold: reader.readUInt16(),
    expiry: Expiry.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  NewDkgDetails.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  static final _hasher = cl.getTaggedHasher("NewDkgDetails");

  @override
  Uint8List get uncachedSigHash => _hasher(toBytes());

  @override
  void write(cl.Writer writer) {
    writer.writeString(name);
    writer.writeString(description);
    writer.writeUInt16(threshold);
    expiry.write(writer);
  }

  /// Hash of DKG details and commiments that participants verify is equal for
  /// every other participant for round 2.
  ///
  /// Does a simple XOR as both hashes are not biased.
  Uint8List hashWithCommitments(
    DkgCommitmentSet commitments,
  ) => Uint8List.fromList(
    List<int>.generate(32, (i) => sigHash[i] ^ commitments.hash[i]),
  );

}
