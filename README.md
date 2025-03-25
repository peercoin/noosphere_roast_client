# Noosphere Client for ROAST Threshold Signatures

This Dart library provides a `Client` class to communicate with a Noosphere
coordinator server for the generation of FROST keys and Taproot Schnorr
threshold signatures using coordinated Distributed Key Generation and ROAST.

This allows generation of one or more m-of-n threshold keys for a group of
participants given by a `GroupConfig`. Clients can request new DKGs or
signatures from the group, and may accept or reject requests made by others.

Consumers of the library should usually use the high-level `Client` class. The
`login()` method allows a client to login with a given `ClientConfig` and
`ClientStorageInterface` with a getter function to obtain the client's private
key. The `GrpcClientApi` can be used as an `ApiRequestInterface` to communicate
with a coordinator server over gRPC.

The server and the `Client` class tests are not included under this repository.
The `Client` class integration with the server is tested elsewhere.

## Installation

To use the library, the underlying [frosty](https://pub.dev/packages/frosty)
package requires the associated native library which can be built from the
[frosty repository](https://github.com/peercoin/frosty) using Podman or Docker.
Linux and Android builds are supported and require placing the libraries in the
necessary location. Please see the
[frosty README.md](https://github.com/peercoin/frosty).
