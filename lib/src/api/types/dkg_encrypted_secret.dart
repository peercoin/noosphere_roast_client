import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';

class DkgEncryptedSecret {

  final ECCiphertext ciphertext;

  DkgEncryptedSecret(this.ciphertext);

  /// Encrypts a [secretShare] for a [recipientKey] using the [senderKey].
  DkgEncryptedSecret.encrypt({
    required DkgShareToGive secretShare,
    required cl.ECPublicKey recipientKey,
    required cl.ECPrivateKey senderKey,
  }) : ciphertext = ECCiphertext.encrypt(
    plaintext: secretShare.toBytes(),
    recipientKey: recipientKey,
    senderKey: senderKey,
  );

  /// Decrypts the [DkgShareToGive] or returns null if it cannot be decrypted
  /// and authenticated as a valid [DkgShareToGive].
  DkgShareToGive? decrypt({
    required cl.ECPrivateKey recipientKey,
    required cl.ECPublicKey senderKey,
  }) {

    final plaintext = ciphertext.decrypt(
      recipientKey: recipientKey,
      senderKey: senderKey,
    );

    try {
      return plaintext == null ? null : DkgShareToGive.fromBytes(plaintext);
    } on InvalidShareToGive {
      return null;
    }

  }

}
