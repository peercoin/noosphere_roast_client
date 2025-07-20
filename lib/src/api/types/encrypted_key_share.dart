import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';

/// An encrypted FROST key secret share for a give participant using ECDH.
class EncryptedKeyShare {

  final ECCiphertext ciphertext;

  EncryptedKeyShare(this.ciphertext);

  /// Encrypts a [keyShare] of a FROST key for a [recipientKey] using the
  /// [senderKey].
  EncryptedKeyShare.encrypt({
    required cl.ECPrivateKey keyShare,
    required cl.ECPublicKey recipientKey,
    required cl.ECPrivateKey senderKey,
  }) : ciphertext = ECCiphertext.encrypt(
    plaintext: keyShare.data,
    recipientKey: recipientKey,
    senderKey: senderKey,
  );

  /// Decrypts the key share for a FROST key or returns null if it cannot be
  /// decrypted and authenticated.
  cl.ECPrivateKey? decrypt({
    required cl.ECPrivateKey recipientKey,
    required cl.ECPublicKey senderKey,
  }) {

    final plaintext = ciphertext.decrypt(
      recipientKey: recipientKey,
      senderKey: senderKey,
    );

    try {
      return plaintext == null ? null : cl.ECPrivateKey(plaintext);
    } on cl.InvalidPrivateKey {
      return null;
    }

  }

}
