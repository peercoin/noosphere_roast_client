//
//  Generated code. Do not modify.
//  source: noosphere.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use signaturesResponseTypeDescriptor instead')
const SignaturesResponseType$json = {
  '1': 'SignaturesResponseType',
  '2': [
    {'1': 'SIGNATURES_RESPONSE_EMPTY', '2': 0},
    {'1': 'SIGNATURES_RESPONSE_NEW_ROUND', '2': 1},
    {'1': 'SIGNATURES_RESPONSE_COMPLETE', '2': 2},
  ],
};

/// Descriptor for `SignaturesResponseType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List signaturesResponseTypeDescriptor = $convert.base64Decode(
    'ChZTaWduYXR1cmVzUmVzcG9uc2VUeXBlEh0KGVNJR05BVFVSRVNfUkVTUE9OU0VfRU1QVFkQAB'
    'IhCh1TSUdOQVRVUkVTX1JFU1BPTlNFX05FV19ST1VORBABEiAKHFNJR05BVFVSRVNfUkVTUE9O'
    'U0VfQ09NUExFVEUQAg==');

@$core.Deprecated('Use eventTypeDescriptor instead')
const EventType$json = {
  '1': 'EventType',
  '2': [
    {'1': 'PARTICIPANT_STATUS_EVENT', '2': 0},
    {'1': 'NEW_DKG_EVENT', '2': 1},
    {'1': 'DKG_COMMITMENT_EVENT', '2': 2},
    {'1': 'DKG_REJECT_EVENT', '2': 3},
    {'1': 'DKG_ROUND2_SHARE_EVENT', '2': 4},
    {'1': 'DKG_ACK_EVENT', '2': 5},
    {'1': 'DKG_ACK_REQUEST_EVENT', '2': 6},
    {'1': 'SIG_REQ_EVENT', '2': 7},
    {'1': 'SIG_NEW_ROUNDS_EVENT', '2': 8},
    {'1': 'SIG_COMPLETE_EVENT', '2': 9},
    {'1': 'SIG_FAILURE_EVENT', '2': 10},
    {'1': 'KEEPALIVE_EVENT', '2': 11},
    {'1': 'SECRET_SHARE_EVENT', '2': 12},
  ],
};

/// Descriptor for `EventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventTypeDescriptor = $convert.base64Decode(
    'CglFdmVudFR5cGUSHAoYUEFSVElDSVBBTlRfU1RBVFVTX0VWRU5UEAASEQoNTkVXX0RLR19FVk'
    'VOVBABEhgKFERLR19DT01NSVRNRU5UX0VWRU5UEAISFAoQREtHX1JFSkVDVF9FVkVOVBADEhoK'
    'FkRLR19ST1VORDJfU0hBUkVfRVZFTlQQBBIRCg1ES0dfQUNLX0VWRU5UEAUSGQoVREtHX0FDS1'
    '9SRVFVRVNUX0VWRU5UEAYSEQoNU0lHX1JFUV9FVkVOVBAHEhgKFFNJR19ORVdfUk9VTkRTX0VW'
    'RU5UEAgSFgoSU0lHX0NPTVBMRVRFX0VWRU5UEAkSFQoRU0lHX0ZBSUxVUkVfRVZFTlQQChITCg'
    '9LRUVQQUxJVkVfRVZFTlQQCxIWChJTRUNSRVRfU0hBUkVfRVZFTlQQDA==');

@$core.Deprecated('Use bytesDescriptor instead')
const Bytes$json = {
  '1': 'Bytes',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Bytes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bytesDescriptor = $convert.base64Decode(
    'CgVCeXRlcxISCgRkYXRhGAEgASgMUgRkYXRh');

@$core.Deprecated('Use repeatedBytesDescriptor instead')
const RepeatedBytes$json = {
  '1': 'RepeatedBytes',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `RepeatedBytes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repeatedBytesDescriptor = $convert.base64Decode(
    'Cg1SZXBlYXRlZEJ5dGVzEhIKBGRhdGEYASADKAxSBGRhdGE=');

@$core.Deprecated('Use signaturesResponseDescriptor instead')
const SignaturesResponse$json = {
  '1': 'SignaturesResponse',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.noosphere.SignaturesResponseType', '10': 'type'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `SignaturesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signaturesResponseDescriptor = $convert.base64Decode(
    'ChJTaWduYXR1cmVzUmVzcG9uc2USNQoEdHlwZRgBIAEoDjIhLm5vb3NwaGVyZS5TaWduYXR1cm'
    'VzUmVzcG9uc2VUeXBlUgR0eXBlEhIKBGRhdGEYAiABKAxSBGRhdGE=');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'group_fingerprint', '3': 1, '4': 1, '5': 12, '10': 'groupFingerprint'},
    {'1': 'participant_id', '3': 2, '4': 1, '5': 12, '10': 'participantId'},
    {'1': 'protocol_version', '3': 3, '4': 1, '5': 13, '10': 'protocolVersion'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSKwoRZ3JvdXBfZmluZ2VycHJpbnQYASABKAxSEGdyb3VwRmluZ2VycH'
    'JpbnQSJQoOcGFydGljaXBhbnRfaWQYAiABKAxSDXBhcnRpY2lwYW50SWQSKQoQcHJvdG9jb2xf'
    'dmVyc2lvbhgDIAEoDVIPcHJvdG9jb2xWZXJzaW9u');

@$core.Deprecated('Use signedAuthChallengeDescriptor instead')
const SignedAuthChallenge$json = {
  '1': 'SignedAuthChallenge',
  '2': [
    {'1': 'signature', '3': 1, '4': 1, '5': 12, '10': 'signature'},
    {'1': 'challenge', '3': 2, '4': 1, '5': 12, '10': 'challenge'},
  ],
};

/// Descriptor for `SignedAuthChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signedAuthChallengeDescriptor = $convert.base64Decode(
    'ChNTaWduZWRBdXRoQ2hhbGxlbmdlEhwKCXNpZ25hdHVyZRgBIAEoDFIJc2lnbmF0dXJlEhwKCW'
    'NoYWxsZW5nZRgCIAEoDFIJY2hhbGxlbmdl');

@$core.Deprecated('Use dkgRequestDescriptor instead')
const DkgRequest$json = {
  '1': 'DkgRequest',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'signed_details', '3': 2, '4': 1, '5': 12, '10': 'signedDetails'},
    {'1': 'commitment', '3': 3, '4': 1, '5': 12, '10': 'commitment'},
  ],
};

/// Descriptor for `DkgRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgRequestDescriptor = $convert.base64Decode(
    'CgpEa2dSZXF1ZXN0EhAKA3NpZBgBIAEoDFIDc2lkEiUKDnNpZ25lZF9kZXRhaWxzGAIgASgMUg'
    '1zaWduZWREZXRhaWxzEh4KCmNvbW1pdG1lbnQYAyABKAxSCmNvbW1pdG1lbnQ=');

@$core.Deprecated('Use dkgToRejectDescriptor instead')
const DkgToReject$json = {
  '1': 'DkgToReject',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `DkgToReject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgToRejectDescriptor = $convert.base64Decode(
    'CgtEa2dUb1JlamVjdBIQCgNzaWQYASABKAxSA3NpZBISCgRuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use dkgCommitmentDescriptor instead')
const DkgCommitment$json = {
  '1': 'DkgCommitment',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'commitment', '3': 3, '4': 1, '5': 12, '10': 'commitment'},
  ],
};

/// Descriptor for `DkgCommitment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgCommitmentDescriptor = $convert.base64Decode(
    'Cg1Ea2dDb21taXRtZW50EhAKA3NpZBgBIAEoDFIDc2lkEhIKBG5hbWUYAiABKAlSBG5hbWUSHg'
    'oKY29tbWl0bWVudBgDIAEoDFIKY29tbWl0bWVudA==');

@$core.Deprecated('Use dkgSecretDescriptor instead')
const DkgSecret$json = {
  '1': 'DkgSecret',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 12, '10': 'id'},
    {'1': 'secret', '3': 2, '4': 1, '5': 12, '10': 'secret'},
  ],
};

/// Descriptor for `DkgSecret`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgSecretDescriptor = $convert.base64Decode(
    'CglEa2dTZWNyZXQSDgoCaWQYASABKAxSAmlkEhYKBnNlY3JldBgCIAEoDFIGc2VjcmV0');

@$core.Deprecated('Use dkgRound2Descriptor instead')
const DkgRound2$json = {
  '1': 'DkgRound2',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'commitment_set_signature', '3': 3, '4': 1, '5': 12, '10': 'commitmentSetSignature'},
    {'1': 'secrets', '3': 4, '4': 3, '5': 11, '6': '.noosphere.DkgSecret', '10': 'secrets'},
  ],
};

/// Descriptor for `DkgRound2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgRound2Descriptor = $convert.base64Decode(
    'CglEa2dSb3VuZDISEAoDc2lkGAEgASgMUgNzaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRI4Chhjb2'
    '1taXRtZW50X3NldF9zaWduYXR1cmUYAyABKAxSFmNvbW1pdG1lbnRTZXRTaWduYXR1cmUSLgoH'
    'c2VjcmV0cxgEIAMoCzIULm5vb3NwaGVyZS5Ea2dTZWNyZXRSB3NlY3JldHM=');

@$core.Deprecated('Use dkgAcksDescriptor instead')
const DkgAcks$json = {
  '1': 'DkgAcks',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'acks', '3': 2, '4': 3, '5': 12, '10': 'acks'},
  ],
};

/// Descriptor for `DkgAcks`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgAcksDescriptor = $convert.base64Decode(
    'CgdEa2dBY2tzEhAKA3NpZBgBIAEoDFIDc2lkEhIKBGFja3MYAiADKAxSBGFja3M=');

@$core.Deprecated('Use dkgAckRequestDescriptor instead')
const DkgAckRequest$json = {
  '1': 'DkgAckRequest',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'requests', '3': 2, '4': 3, '5': 12, '10': 'requests'},
  ],
};

/// Descriptor for `DkgAckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dkgAckRequestDescriptor = $convert.base64Decode(
    'Cg1Ea2dBY2tSZXF1ZXN0EhAKA3NpZBgBIAEoDFIDc2lkEhoKCHJlcXVlc3RzGAIgAygMUghyZX'
    'F1ZXN0cw==');

@$core.Deprecated('Use signaturesRequestDescriptor instead')
const SignaturesRequest$json = {
  '1': 'SignaturesRequest',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'keys', '3': 2, '4': 3, '5': 12, '10': 'keys'},
    {'1': 'signed_details', '3': 3, '4': 1, '5': 12, '10': 'signedDetails'},
    {'1': 'commitments', '3': 4, '4': 3, '5': 12, '10': 'commitments'},
  ],
};

/// Descriptor for `SignaturesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signaturesRequestDescriptor = $convert.base64Decode(
    'ChFTaWduYXR1cmVzUmVxdWVzdBIQCgNzaWQYASABKAxSA3NpZBISCgRrZXlzGAIgAygMUgRrZX'
    'lzEiUKDnNpZ25lZF9kZXRhaWxzGAMgASgMUg1zaWduZWREZXRhaWxzEiAKC2NvbW1pdG1lbnRz'
    'GAQgAygMUgtjb21taXRtZW50cw==');

@$core.Deprecated('Use signaturesRejectionDescriptor instead')
const SignaturesRejection$json = {
  '1': 'SignaturesRejection',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'req_id', '3': 2, '4': 1, '5': 12, '10': 'reqId'},
  ],
};

/// Descriptor for `SignaturesRejection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signaturesRejectionDescriptor = $convert.base64Decode(
    'ChNTaWduYXR1cmVzUmVqZWN0aW9uEhAKA3NpZBgBIAEoDFIDc2lkEhUKBnJlcV9pZBgCIAEoDF'
    'IFcmVxSWQ=');

@$core.Deprecated('Use signaturesRepliesDescriptor instead')
const SignaturesReplies$json = {
  '1': 'SignaturesReplies',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'req_id', '3': 2, '4': 1, '5': 12, '10': 'reqId'},
    {'1': 'replies', '3': 3, '4': 3, '5': 12, '10': 'replies'},
  ],
};

/// Descriptor for `SignaturesReplies`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signaturesRepliesDescriptor = $convert.base64Decode(
    'ChFTaWduYXR1cmVzUmVwbGllcxIQCgNzaWQYASABKAxSA3NpZBIVCgZyZXFfaWQYAiABKAxSBX'
    'JlcUlkEhgKB3JlcGxpZXMYAyADKAxSB3JlcGxpZXM=');

@$core.Deprecated('Use encryptedSecretDescriptor instead')
const EncryptedSecret$json = {
  '1': 'EncryptedSecret',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 12, '10': 'id'},
    {'1': 'share', '3': 2, '4': 1, '5': 12, '10': 'share'},
  ],
};

/// Descriptor for `EncryptedSecret`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encryptedSecretDescriptor = $convert.base64Decode(
    'Cg9FbmNyeXB0ZWRTZWNyZXQSDgoCaWQYASABKAxSAmlkEhQKBXNoYXJlGAIgASgMUgVzaGFyZQ'
    '==');

@$core.Deprecated('Use secretShareDescriptor instead')
const SecretShare$json = {
  '1': 'SecretShare',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 12, '10': 'sid'},
    {'1': 'group_key', '3': 2, '4': 1, '5': 12, '10': 'groupKey'},
    {'1': 'secrets', '3': 3, '4': 3, '5': 11, '6': '.noosphere.EncryptedSecret', '10': 'secrets'},
  ],
};

/// Descriptor for `SecretShare`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretShareDescriptor = $convert.base64Decode(
    'CgtTZWNyZXRTaGFyZRIQCgNzaWQYASABKAxSA3NpZBIbCglncm91cF9rZXkYAiABKAxSCGdyb3'
    'VwS2V5EjQKB3NlY3JldHMYAyADKAsyGi5ub29zcGhlcmUuRW5jcnlwdGVkU2VjcmV0UgdzZWNy'
    'ZXRz');

@$core.Deprecated('Use eventsDescriptor instead')
const Events$json = {
  '1': 'Events',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.noosphere.EventType', '10': 'type'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Events`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventsDescriptor = $convert.base64Decode(
    'CgZFdmVudHMSKAoEdHlwZRgBIAEoDjIULm5vb3NwaGVyZS5FdmVudFR5cGVSBHR5cGUSEgoEZG'
    'F0YRgCIAEoDFIEZGF0YQ==');

