//
//  Generated code. Do not modify.
//  source: noosphere.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'noosphere.pb.dart' as $0;

export 'noosphere.pb.dart';

@$pb.GrpcServiceName('noosphere.Noosphere')
class NoosphereClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.Bytes>(
      '/noosphere.Noosphere/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Bytes.fromBuffer(value));
  static final _$respondToChallenge = $grpc.ClientMethod<$0.SignedAuthChallenge, $0.Bytes>(
      '/noosphere.Noosphere/RespondToChallenge',
      ($0.SignedAuthChallenge value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Bytes.fromBuffer(value));
  static final _$fetchEventStream = $grpc.ClientMethod<$0.Bytes, $0.Events>(
      '/noosphere.Noosphere/FetchEventStream',
      ($0.Bytes value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Events.fromBuffer(value));
  static final _$extendSession = $grpc.ClientMethod<$0.Bytes, $0.Bytes>(
      '/noosphere.Noosphere/ExtendSession',
      ($0.Bytes value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Bytes.fromBuffer(value));
  static final _$requestNewDkg = $grpc.ClientMethod<$0.DkgRequest, $0.Empty>(
      '/noosphere.Noosphere/RequestNewDkg',
      ($0.DkgRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$rejectDkg = $grpc.ClientMethod<$0.DkgToReject, $0.Empty>(
      '/noosphere.Noosphere/RejectDkg',
      ($0.DkgToReject value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$submitDkgCommitment = $grpc.ClientMethod<$0.DkgCommitment, $0.Empty>(
      '/noosphere.Noosphere/SubmitDkgCommitment',
      ($0.DkgCommitment value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$submitDkgRound2 = $grpc.ClientMethod<$0.DkgRound2, $0.Empty>(
      '/noosphere.Noosphere/SubmitDkgRound2',
      ($0.DkgRound2 value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$sendDkgAcks = $grpc.ClientMethod<$0.DkgAcks, $0.Empty>(
      '/noosphere.Noosphere/SendDkgAcks',
      ($0.DkgAcks value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$requestDkgAcks = $grpc.ClientMethod<$0.DkgAckRequest, $0.RepeatedBytes>(
      '/noosphere.Noosphere/RequestDkgAcks',
      ($0.DkgAckRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RepeatedBytes.fromBuffer(value));
  static final _$requestSignatures = $grpc.ClientMethod<$0.SignaturesRequest, $0.Empty>(
      '/noosphere.Noosphere/RequestSignatures',
      ($0.SignaturesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$rejectSignaturesRequest = $grpc.ClientMethod<$0.SignaturesRejection, $0.Empty>(
      '/noosphere.Noosphere/RejectSignaturesRequest',
      ($0.SignaturesRejection value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$submitSignatureReplies = $grpc.ClientMethod<$0.SignaturesReplies, $0.SignaturesResponse>(
      '/noosphere.Noosphere/SubmitSignatureReplies',
      ($0.SignaturesReplies value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SignaturesResponse.fromBuffer(value));
  static final _$shareSecretShare = $grpc.ClientMethod<$0.SecretShare, $0.RepeatedBytes>(
      '/noosphere.Noosphere/ShareSecretShare',
      ($0.SecretShare value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RepeatedBytes.fromBuffer(value));
  static final _$ackKeyConstructed = $grpc.ClientMethod<$0.ConstructedKey, $0.Empty>(
      '/noosphere.Noosphere/AckKeyConstructed',
      ($0.ConstructedKey value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  NoosphereClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Bytes> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$0.Bytes> respondToChallenge($0.SignedAuthChallenge request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$respondToChallenge, request, options: options);
  }

  $grpc.ResponseStream<$0.Events> fetchEventStream($0.Bytes request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$fetchEventStream, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.Bytes> extendSession($0.Bytes request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$extendSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> requestNewDkg($0.DkgRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestNewDkg, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> rejectDkg($0.DkgToReject request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rejectDkg, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> submitDkgCommitment($0.DkgCommitment request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$submitDkgCommitment, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> submitDkgRound2($0.DkgRound2 request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$submitDkgRound2, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> sendDkgAcks($0.DkgAcks request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendDkgAcks, request, options: options);
  }

  $grpc.ResponseFuture<$0.RepeatedBytes> requestDkgAcks($0.DkgAckRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestDkgAcks, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> requestSignatures($0.SignaturesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestSignatures, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> rejectSignaturesRequest($0.SignaturesRejection request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rejectSignaturesRequest, request, options: options);
  }

  $grpc.ResponseFuture<$0.SignaturesResponse> submitSignatureReplies($0.SignaturesReplies request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$submitSignatureReplies, request, options: options);
  }

  $grpc.ResponseFuture<$0.RepeatedBytes> shareSecretShare($0.SecretShare request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$shareSecretShare, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> ackKeyConstructed($0.ConstructedKey request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ackKeyConstructed, request, options: options);
  }
}

@$pb.GrpcServiceName('noosphere.Noosphere')
abstract class NoosphereServiceBase extends $grpc.Service {
  $core.String get $name => 'noosphere.Noosphere';

  NoosphereServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.Bytes>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.Bytes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignedAuthChallenge, $0.Bytes>(
        'RespondToChallenge',
        respondToChallenge_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignedAuthChallenge.fromBuffer(value),
        ($0.Bytes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Bytes, $0.Events>(
        'FetchEventStream',
        fetchEventStream_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Bytes.fromBuffer(value),
        ($0.Events value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Bytes, $0.Bytes>(
        'ExtendSession',
        extendSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Bytes.fromBuffer(value),
        ($0.Bytes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DkgRequest, $0.Empty>(
        'RequestNewDkg',
        requestNewDkg_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DkgRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DkgToReject, $0.Empty>(
        'RejectDkg',
        rejectDkg_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DkgToReject.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DkgCommitment, $0.Empty>(
        'SubmitDkgCommitment',
        submitDkgCommitment_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DkgCommitment.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DkgRound2, $0.Empty>(
        'SubmitDkgRound2',
        submitDkgRound2_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DkgRound2.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DkgAcks, $0.Empty>(
        'SendDkgAcks',
        sendDkgAcks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DkgAcks.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DkgAckRequest, $0.RepeatedBytes>(
        'RequestDkgAcks',
        requestDkgAcks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DkgAckRequest.fromBuffer(value),
        ($0.RepeatedBytes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignaturesRequest, $0.Empty>(
        'RequestSignatures',
        requestSignatures_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignaturesRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignaturesRejection, $0.Empty>(
        'RejectSignaturesRequest',
        rejectSignaturesRequest_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignaturesRejection.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignaturesReplies, $0.SignaturesResponse>(
        'SubmitSignatureReplies',
        submitSignatureReplies_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignaturesReplies.fromBuffer(value),
        ($0.SignaturesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SecretShare, $0.RepeatedBytes>(
        'ShareSecretShare',
        shareSecretShare_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SecretShare.fromBuffer(value),
        ($0.RepeatedBytes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConstructedKey, $0.Empty>(
        'AckKeyConstructed',
        ackKeyConstructed_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ConstructedKey.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Bytes> login_Pre($grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$0.Bytes> respondToChallenge_Pre($grpc.ServiceCall call, $async.Future<$0.SignedAuthChallenge> request) async {
    return respondToChallenge(call, await request);
  }

  $async.Stream<$0.Events> fetchEventStream_Pre($grpc.ServiceCall call, $async.Future<$0.Bytes> request) async* {
    yield* fetchEventStream(call, await request);
  }

  $async.Future<$0.Bytes> extendSession_Pre($grpc.ServiceCall call, $async.Future<$0.Bytes> request) async {
    return extendSession(call, await request);
  }

  $async.Future<$0.Empty> requestNewDkg_Pre($grpc.ServiceCall call, $async.Future<$0.DkgRequest> request) async {
    return requestNewDkg(call, await request);
  }

  $async.Future<$0.Empty> rejectDkg_Pre($grpc.ServiceCall call, $async.Future<$0.DkgToReject> request) async {
    return rejectDkg(call, await request);
  }

  $async.Future<$0.Empty> submitDkgCommitment_Pre($grpc.ServiceCall call, $async.Future<$0.DkgCommitment> request) async {
    return submitDkgCommitment(call, await request);
  }

  $async.Future<$0.Empty> submitDkgRound2_Pre($grpc.ServiceCall call, $async.Future<$0.DkgRound2> request) async {
    return submitDkgRound2(call, await request);
  }

  $async.Future<$0.Empty> sendDkgAcks_Pre($grpc.ServiceCall call, $async.Future<$0.DkgAcks> request) async {
    return sendDkgAcks(call, await request);
  }

  $async.Future<$0.RepeatedBytes> requestDkgAcks_Pre($grpc.ServiceCall call, $async.Future<$0.DkgAckRequest> request) async {
    return requestDkgAcks(call, await request);
  }

  $async.Future<$0.Empty> requestSignatures_Pre($grpc.ServiceCall call, $async.Future<$0.SignaturesRequest> request) async {
    return requestSignatures(call, await request);
  }

  $async.Future<$0.Empty> rejectSignaturesRequest_Pre($grpc.ServiceCall call, $async.Future<$0.SignaturesRejection> request) async {
    return rejectSignaturesRequest(call, await request);
  }

  $async.Future<$0.SignaturesResponse> submitSignatureReplies_Pre($grpc.ServiceCall call, $async.Future<$0.SignaturesReplies> request) async {
    return submitSignatureReplies(call, await request);
  }

  $async.Future<$0.RepeatedBytes> shareSecretShare_Pre($grpc.ServiceCall call, $async.Future<$0.SecretShare> request) async {
    return shareSecretShare(call, await request);
  }

  $async.Future<$0.Empty> ackKeyConstructed_Pre($grpc.ServiceCall call, $async.Future<$0.ConstructedKey> request) async {
    return ackKeyConstructed(call, await request);
  }

  $async.Future<$0.Bytes> login($grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$0.Bytes> respondToChallenge($grpc.ServiceCall call, $0.SignedAuthChallenge request);
  $async.Stream<$0.Events> fetchEventStream($grpc.ServiceCall call, $0.Bytes request);
  $async.Future<$0.Bytes> extendSession($grpc.ServiceCall call, $0.Bytes request);
  $async.Future<$0.Empty> requestNewDkg($grpc.ServiceCall call, $0.DkgRequest request);
  $async.Future<$0.Empty> rejectDkg($grpc.ServiceCall call, $0.DkgToReject request);
  $async.Future<$0.Empty> submitDkgCommitment($grpc.ServiceCall call, $0.DkgCommitment request);
  $async.Future<$0.Empty> submitDkgRound2($grpc.ServiceCall call, $0.DkgRound2 request);
  $async.Future<$0.Empty> sendDkgAcks($grpc.ServiceCall call, $0.DkgAcks request);
  $async.Future<$0.RepeatedBytes> requestDkgAcks($grpc.ServiceCall call, $0.DkgAckRequest request);
  $async.Future<$0.Empty> requestSignatures($grpc.ServiceCall call, $0.SignaturesRequest request);
  $async.Future<$0.Empty> rejectSignaturesRequest($grpc.ServiceCall call, $0.SignaturesRejection request);
  $async.Future<$0.SignaturesResponse> submitSignatureReplies($grpc.ServiceCall call, $0.SignaturesReplies request);
  $async.Future<$0.RepeatedBytes> shareSecretShare($grpc.ServiceCall call, $0.SecretShare request);
  $async.Future<$0.Empty> ackKeyConstructed($grpc.ServiceCall call, $0.ConstructedKey request);
}
