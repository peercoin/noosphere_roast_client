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
