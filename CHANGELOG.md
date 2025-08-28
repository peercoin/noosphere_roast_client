## 3.0.0

This version allows clients to share key-secrets and determine the underlying
private keys of FROST keys.

- Breaking change: Simplify storage interface with `addOrReplaceFrostKey`.
- Breaking change: Add `shareSecretShare` and `ackKeyConstructed` methods to API.
- Breaking change: Add `startTime` and `secretShares` to
    `LoginCompleteResponse`.
- Breaking change: Update to frosty 3.0.0. The 3.0.0 library binary must be used.
- `FrostKeyWithDetails` has additional fields for key construction. The class
    will still read the old serialised binary for this object.
- Add `KeyConstruction` classes.
- Add `shareKeySecret` method to `Client` to share key secret shares.
- Add `SecretShareClientEvent` for receiving key secret shares.
- Bugfixes

## 2.0.0

Update to frosty 2.0.0

## 1.1.0

- Add TaprootTransactionSignatureMetadata to share details for signing Taproot
    transactions.
- Disconnects clients on the first error in the stream.
- Add `dkgExists`.
- Improve async handling and avoid unhandled gRPC errors. gRPC methods will
    timeout after 10 seconds.
- Increase coinlib version to v4

## 1.0.0

- Initial version.
