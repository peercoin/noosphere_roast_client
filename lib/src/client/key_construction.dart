import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';

sealed class KeyConstruction with cl.Writable {

  bool haveForParticipant(Identifier id);

  /// Gives null if the [secret] is not valid for the given [info].
  KeyConstruction? addSecret(
    Identifier id,
    cl.ECPrivateKey secret,
    ParticipantKeyInfo info,
  );

}

class KeyConstructionProgress extends KeyConstruction {

  final Map<Identifier, cl.ECPrivateKey> secrets;

  KeyConstructionProgress._(Map<Identifier, cl.ECPrivateKey> secrets)
    : secrets = Map.unmodifiable(secrets);

  KeyConstructionProgress() : this._({});

  KeyConstructionProgress.fromReader(cl.BytesReader reader) : this._(
    reader.readMap(
      () => reader.readIdentifier(),
      () => reader.readPrivKey(),
    ),
  );

  @override
  bool haveForParticipant(Identifier id) => secrets.containsKey(id);

  @override
  KeyConstruction? addSecret(
    Identifier id,
    cl.ECPrivateKey secret,
    ParticipantKeyInfo info,
  ) {

    // Check secret corresponds to public share
    final pair = info.publicShares.list.firstWhere((pair) => pair.$1 == id);
    if (secret.pubkey != pair.$2) return null;

    final newSecrets = { ...secrets, id: secret };

    if (newSecrets.length == info.group.threshold - 1) {
      // Construct underlying if a threshold is reached
      final constructedKey = info.constructPrivateKey(
        newSecrets.entries.map((entry) => (entry.key, entry.value)).toList(),
      );
      return KeyConstructionComplete(constructedKey);
    }

    return KeyConstructionProgress._(newSecrets);

  }

  @override
  void write(cl.Writer writer) {
    writer.writeMap(
      secrets,
      (id) => writer.writeIdentifier(id),
      (privKey) => writer.writePrivKey(privKey),
    );
  }

}

class KeyConstructionComplete extends KeyConstruction {

  final cl.ECPrivateKey privateKey;

  KeyConstructionComplete(this.privateKey);

  KeyConstructionComplete.fromReader(cl.BytesReader reader) : this(
    reader.readPrivKey(),
  );

  @override
  /// If the construction is complete then act as if all shares were received
  /// even though only a threshold number was because no more shares are needed.
  bool haveForParticipant(Identifier id) => true;

  @override
  /// A no-op because it is already complete
  KeyConstruction addSecret(
    Identifier id,
    cl.ECPrivateKey secret,
    ParticipantKeyInfo info,
  ) => this;

  @override
  void write(cl.Writer writer) {
    writer.writePrivKey(privateKey);
  }

}
