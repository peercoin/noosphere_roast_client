//
//  Generated code. Do not modify.
//  source: noosphere.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'noosphere.pbenum.dart';

export 'noosphere.pbenum.dart';

class Bytes extends $pb.GeneratedMessage {
  factory Bytes({
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Bytes._() : super();
  factory Bytes.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Bytes.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Bytes', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Bytes clone() => Bytes()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Bytes copyWith(void Function(Bytes) updates) => super.copyWith((message) => updates(message as Bytes)) as Bytes;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bytes create() => Bytes._();
  Bytes createEmptyInstance() => create();
  static $pb.PbList<Bytes> createRepeated() => $pb.PbList<Bytes>();
  @$core.pragma('dart2js:noInline')
  static Bytes getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bytes>(create);
  static Bytes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class RepeatedBytes extends $pb.GeneratedMessage {
  factory RepeatedBytes({
    $core.Iterable<$core.List<$core.int>>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  RepeatedBytes._() : super();
  factory RepeatedBytes.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepeatedBytes.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepeatedBytes', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepeatedBytes clone() => RepeatedBytes()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepeatedBytes copyWith(void Function(RepeatedBytes) updates) => super.copyWith((message) => updates(message as RepeatedBytes)) as RepeatedBytes;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepeatedBytes create() => RepeatedBytes._();
  RepeatedBytes createEmptyInstance() => create();
  static $pb.PbList<RepeatedBytes> createRepeated() => $pb.PbList<RepeatedBytes>();
  @$core.pragma('dart2js:noInline')
  static RepeatedBytes getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepeatedBytes>(create);
  static RepeatedBytes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.List<$core.int>> get data => $_getList(0);
}

class SignaturesResponse extends $pb.GeneratedMessage {
  factory SignaturesResponse({
    SignaturesResponseType? type,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  SignaturesResponse._() : super();
  factory SignaturesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignaturesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignaturesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..e<SignaturesResponseType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: SignaturesResponseType.SIGNATURES_RESPONSE_EMPTY, valueOf: SignaturesResponseType.valueOf, enumValues: SignaturesResponseType.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignaturesResponse clone() => SignaturesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignaturesResponse copyWith(void Function(SignaturesResponse) updates) => super.copyWith((message) => updates(message as SignaturesResponse)) as SignaturesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignaturesResponse create() => SignaturesResponse._();
  SignaturesResponse createEmptyInstance() => create();
  static $pb.PbList<SignaturesResponse> createRepeated() => $pb.PbList<SignaturesResponse>();
  @$core.pragma('dart2js:noInline')
  static SignaturesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignaturesResponse>(create);
  static SignaturesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SignaturesResponseType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SignaturesResponseType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();
  Empty._() : super();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Empty', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.List<$core.int>? groupFingerprint,
    $core.List<$core.int>? participantId,
    $core.int? protocolVersion,
  }) {
    final $result = create();
    if (groupFingerprint != null) {
      $result.groupFingerprint = groupFingerprint;
    }
    if (participantId != null) {
      $result.participantId = participantId;
    }
    if (protocolVersion != null) {
      $result.protocolVersion = protocolVersion;
    }
    return $result;
  }
  LoginRequest._() : super();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'groupFingerprint', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'participantId', $pb.PbFieldType.OY)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'protocolVersion', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get groupFingerprint => $_getN(0);
  @$pb.TagNumber(1)
  set groupFingerprint($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupFingerprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupFingerprint() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get participantId => $_getN(1);
  @$pb.TagNumber(2)
  set participantId($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipantId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipantId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get protocolVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set protocolVersion($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProtocolVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearProtocolVersion() => clearField(3);
}

class SignedAuthChallenge extends $pb.GeneratedMessage {
  factory SignedAuthChallenge({
    $core.List<$core.int>? signature,
    $core.List<$core.int>? challenge,
  }) {
    final $result = create();
    if (signature != null) {
      $result.signature = signature;
    }
    if (challenge != null) {
      $result.challenge = challenge;
    }
    return $result;
  }
  SignedAuthChallenge._() : super();
  factory SignedAuthChallenge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignedAuthChallenge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignedAuthChallenge', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'challenge', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignedAuthChallenge clone() => SignedAuthChallenge()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignedAuthChallenge copyWith(void Function(SignedAuthChallenge) updates) => super.copyWith((message) => updates(message as SignedAuthChallenge)) as SignedAuthChallenge;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignedAuthChallenge create() => SignedAuthChallenge._();
  SignedAuthChallenge createEmptyInstance() => create();
  static $pb.PbList<SignedAuthChallenge> createRepeated() => $pb.PbList<SignedAuthChallenge>();
  @$core.pragma('dart2js:noInline')
  static SignedAuthChallenge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignedAuthChallenge>(create);
  static SignedAuthChallenge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get signature => $_getN(0);
  @$pb.TagNumber(1)
  set signature($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignature() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignature() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get challenge => $_getN(1);
  @$pb.TagNumber(2)
  set challenge($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChallenge() => $_has(1);
  @$pb.TagNumber(2)
  void clearChallenge() => clearField(2);
}

class DkgRequest extends $pb.GeneratedMessage {
  factory DkgRequest({
    $core.List<$core.int>? sid,
    $core.List<$core.int>? signedDetails,
    $core.List<$core.int>? commitment,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (signedDetails != null) {
      $result.signedDetails = signedDetails;
    }
    if (commitment != null) {
      $result.commitment = commitment;
    }
    return $result;
  }
  DkgRequest._() : super();
  factory DkgRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'signedDetails', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'commitment', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgRequest clone() => DkgRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgRequest copyWith(void Function(DkgRequest) updates) => super.copyWith((message) => updates(message as DkgRequest)) as DkgRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgRequest create() => DkgRequest._();
  DkgRequest createEmptyInstance() => create();
  static $pb.PbList<DkgRequest> createRepeated() => $pb.PbList<DkgRequest>();
  @$core.pragma('dart2js:noInline')
  static DkgRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgRequest>(create);
  static DkgRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signedDetails => $_getN(1);
  @$pb.TagNumber(2)
  set signedDetails($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignedDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignedDetails() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get commitment => $_getN(2);
  @$pb.TagNumber(3)
  set commitment($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommitment() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommitment() => clearField(3);
}

class DkgToReject extends $pb.GeneratedMessage {
  factory DkgToReject({
    $core.List<$core.int>? sid,
    $core.String? name,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  DkgToReject._() : super();
  factory DkgToReject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgToReject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgToReject', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgToReject clone() => DkgToReject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgToReject copyWith(void Function(DkgToReject) updates) => super.copyWith((message) => updates(message as DkgToReject)) as DkgToReject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgToReject create() => DkgToReject._();
  DkgToReject createEmptyInstance() => create();
  static $pb.PbList<DkgToReject> createRepeated() => $pb.PbList<DkgToReject>();
  @$core.pragma('dart2js:noInline')
  static DkgToReject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgToReject>(create);
  static DkgToReject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class DkgCommitment extends $pb.GeneratedMessage {
  factory DkgCommitment({
    $core.List<$core.int>? sid,
    $core.String? name,
    $core.List<$core.int>? commitment,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (name != null) {
      $result.name = name;
    }
    if (commitment != null) {
      $result.commitment = commitment;
    }
    return $result;
  }
  DkgCommitment._() : super();
  factory DkgCommitment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgCommitment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgCommitment', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'commitment', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgCommitment clone() => DkgCommitment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgCommitment copyWith(void Function(DkgCommitment) updates) => super.copyWith((message) => updates(message as DkgCommitment)) as DkgCommitment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgCommitment create() => DkgCommitment._();
  DkgCommitment createEmptyInstance() => create();
  static $pb.PbList<DkgCommitment> createRepeated() => $pb.PbList<DkgCommitment>();
  @$core.pragma('dart2js:noInline')
  static DkgCommitment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgCommitment>(create);
  static DkgCommitment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get commitment => $_getN(2);
  @$pb.TagNumber(3)
  set commitment($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommitment() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommitment() => clearField(3);
}

class DkgSecret extends $pb.GeneratedMessage {
  factory DkgSecret({
    $core.List<$core.int>? id,
    $core.List<$core.int>? secret,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (secret != null) {
      $result.secret = secret;
    }
    return $result;
  }
  DkgSecret._() : super();
  factory DkgSecret.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgSecret.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgSecret', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'secret', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgSecret clone() => DkgSecret()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgSecret copyWith(void Function(DkgSecret) updates) => super.copyWith((message) => updates(message as DkgSecret)) as DkgSecret;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgSecret create() => DkgSecret._();
  DkgSecret createEmptyInstance() => create();
  static $pb.PbList<DkgSecret> createRepeated() => $pb.PbList<DkgSecret>();
  @$core.pragma('dart2js:noInline')
  static DkgSecret getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgSecret>(create);
  static DkgSecret? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get id => $_getN(0);
  @$pb.TagNumber(1)
  set id($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get secret => $_getN(1);
  @$pb.TagNumber(2)
  set secret($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecret() => clearField(2);
}

class DkgRound2 extends $pb.GeneratedMessage {
  factory DkgRound2({
    $core.List<$core.int>? sid,
    $core.String? name,
    $core.List<$core.int>? commitmentSetSignature,
    $core.Iterable<DkgSecret>? secrets,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (name != null) {
      $result.name = name;
    }
    if (commitmentSetSignature != null) {
      $result.commitmentSetSignature = commitmentSetSignature;
    }
    if (secrets != null) {
      $result.secrets.addAll(secrets);
    }
    return $result;
  }
  DkgRound2._() : super();
  factory DkgRound2.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgRound2.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgRound2', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'commitmentSetSignature', $pb.PbFieldType.OY)
    ..pc<DkgSecret>(4, _omitFieldNames ? '' : 'secrets', $pb.PbFieldType.PM, subBuilder: DkgSecret.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgRound2 clone() => DkgRound2()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgRound2 copyWith(void Function(DkgRound2) updates) => super.copyWith((message) => updates(message as DkgRound2)) as DkgRound2;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgRound2 create() => DkgRound2._();
  DkgRound2 createEmptyInstance() => create();
  static $pb.PbList<DkgRound2> createRepeated() => $pb.PbList<DkgRound2>();
  @$core.pragma('dart2js:noInline')
  static DkgRound2 getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgRound2>(create);
  static DkgRound2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get commitmentSetSignature => $_getN(2);
  @$pb.TagNumber(3)
  set commitmentSetSignature($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommitmentSetSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommitmentSetSignature() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<DkgSecret> get secrets => $_getList(3);
}

class DkgAcks extends $pb.GeneratedMessage {
  factory DkgAcks({
    $core.List<$core.int>? sid,
    $core.Iterable<$core.List<$core.int>>? acks,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (acks != null) {
      $result.acks.addAll(acks);
    }
    return $result;
  }
  DkgAcks._() : super();
  factory DkgAcks.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgAcks.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgAcks', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'acks', $pb.PbFieldType.PY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgAcks clone() => DkgAcks()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgAcks copyWith(void Function(DkgAcks) updates) => super.copyWith((message) => updates(message as DkgAcks)) as DkgAcks;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgAcks create() => DkgAcks._();
  DkgAcks createEmptyInstance() => create();
  static $pb.PbList<DkgAcks> createRepeated() => $pb.PbList<DkgAcks>();
  @$core.pragma('dart2js:noInline')
  static DkgAcks getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgAcks>(create);
  static DkgAcks? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.List<$core.int>> get acks => $_getList(1);
}

class DkgAckRequest extends $pb.GeneratedMessage {
  factory DkgAckRequest({
    $core.List<$core.int>? sid,
    $core.Iterable<$core.List<$core.int>>? requests,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (requests != null) {
      $result.requests.addAll(requests);
    }
    return $result;
  }
  DkgAckRequest._() : super();
  factory DkgAckRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DkgAckRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DkgAckRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'requests', $pb.PbFieldType.PY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DkgAckRequest clone() => DkgAckRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DkgAckRequest copyWith(void Function(DkgAckRequest) updates) => super.copyWith((message) => updates(message as DkgAckRequest)) as DkgAckRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DkgAckRequest create() => DkgAckRequest._();
  DkgAckRequest createEmptyInstance() => create();
  static $pb.PbList<DkgAckRequest> createRepeated() => $pb.PbList<DkgAckRequest>();
  @$core.pragma('dart2js:noInline')
  static DkgAckRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DkgAckRequest>(create);
  static DkgAckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.List<$core.int>> get requests => $_getList(1);
}

class SignaturesRequest extends $pb.GeneratedMessage {
  factory SignaturesRequest({
    $core.List<$core.int>? sid,
    $core.Iterable<$core.List<$core.int>>? keys,
    $core.List<$core.int>? signedDetails,
    $core.Iterable<$core.List<$core.int>>? commitments,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (keys != null) {
      $result.keys.addAll(keys);
    }
    if (signedDetails != null) {
      $result.signedDetails = signedDetails;
    }
    if (commitments != null) {
      $result.commitments.addAll(commitments);
    }
    return $result;
  }
  SignaturesRequest._() : super();
  factory SignaturesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignaturesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignaturesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'keys', $pb.PbFieldType.PY)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'signedDetails', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'commitments', $pb.PbFieldType.PY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignaturesRequest clone() => SignaturesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignaturesRequest copyWith(void Function(SignaturesRequest) updates) => super.copyWith((message) => updates(message as SignaturesRequest)) as SignaturesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignaturesRequest create() => SignaturesRequest._();
  SignaturesRequest createEmptyInstance() => create();
  static $pb.PbList<SignaturesRequest> createRepeated() => $pb.PbList<SignaturesRequest>();
  @$core.pragma('dart2js:noInline')
  static SignaturesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignaturesRequest>(create);
  static SignaturesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.List<$core.int>> get keys => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get signedDetails => $_getN(2);
  @$pb.TagNumber(3)
  set signedDetails($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSignedDetails() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignedDetails() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.List<$core.int>> get commitments => $_getList(3);
}

class SignaturesRejection extends $pb.GeneratedMessage {
  factory SignaturesRejection({
    $core.List<$core.int>? sid,
    $core.List<$core.int>? reqId,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (reqId != null) {
      $result.reqId = reqId;
    }
    return $result;
  }
  SignaturesRejection._() : super();
  factory SignaturesRejection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignaturesRejection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignaturesRejection', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'reqId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignaturesRejection clone() => SignaturesRejection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignaturesRejection copyWith(void Function(SignaturesRejection) updates) => super.copyWith((message) => updates(message as SignaturesRejection)) as SignaturesRejection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignaturesRejection create() => SignaturesRejection._();
  SignaturesRejection createEmptyInstance() => create();
  static $pb.PbList<SignaturesRejection> createRepeated() => $pb.PbList<SignaturesRejection>();
  @$core.pragma('dart2js:noInline')
  static SignaturesRejection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignaturesRejection>(create);
  static SignaturesRejection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get reqId => $_getN(1);
  @$pb.TagNumber(2)
  set reqId($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReqId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReqId() => clearField(2);
}

class SignaturesReplies extends $pb.GeneratedMessage {
  factory SignaturesReplies({
    $core.List<$core.int>? sid,
    $core.List<$core.int>? reqId,
    $core.Iterable<$core.List<$core.int>>? replies,
  }) {
    final $result = create();
    if (sid != null) {
      $result.sid = sid;
    }
    if (reqId != null) {
      $result.reqId = reqId;
    }
    if (replies != null) {
      $result.replies.addAll(replies);
    }
    return $result;
  }
  SignaturesReplies._() : super();
  factory SignaturesReplies.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignaturesReplies.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignaturesReplies', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sid', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'reqId', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'replies', $pb.PbFieldType.PY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignaturesReplies clone() => SignaturesReplies()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignaturesReplies copyWith(void Function(SignaturesReplies) updates) => super.copyWith((message) => updates(message as SignaturesReplies)) as SignaturesReplies;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignaturesReplies create() => SignaturesReplies._();
  SignaturesReplies createEmptyInstance() => create();
  static $pb.PbList<SignaturesReplies> createRepeated() => $pb.PbList<SignaturesReplies>();
  @$core.pragma('dart2js:noInline')
  static SignaturesReplies getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignaturesReplies>(create);
  static SignaturesReplies? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sid => $_getN(0);
  @$pb.TagNumber(1)
  set sid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get reqId => $_getN(1);
  @$pb.TagNumber(2)
  set reqId($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReqId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReqId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.List<$core.int>> get replies => $_getList(2);
}

class Events extends $pb.GeneratedMessage {
  factory Events({
    EventType? type,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Events._() : super();
  factory Events.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Events.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Events', package: const $pb.PackageName(_omitMessageNames ? '' : 'noosphere'), createEmptyInstance: create)
    ..e<EventType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: EventType.PARTICIPANT_STATUS_EVENT, valueOf: EventType.valueOf, enumValues: EventType.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Events clone() => Events()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Events copyWith(void Function(Events) updates) => super.copyWith((message) => updates(message as Events)) as Events;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Events create() => Events._();
  Events createEmptyInstance() => create();
  static $pb.PbList<Events> createRepeated() => $pb.PbList<Events>();
  @$core.pragma('dart2js:noInline')
  static Events getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Events>(create);
  static Events? _defaultInstance;

  @$pb.TagNumber(1)
  EventType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(EventType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
