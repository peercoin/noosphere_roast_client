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

class SignaturesResponseType extends $pb.ProtobufEnum {
  static const SignaturesResponseType SIGNATURES_RESPONSE_EMPTY = SignaturesResponseType._(0, _omitEnumNames ? '' : 'SIGNATURES_RESPONSE_EMPTY');
  static const SignaturesResponseType SIGNATURES_RESPONSE_NEW_ROUND = SignaturesResponseType._(1, _omitEnumNames ? '' : 'SIGNATURES_RESPONSE_NEW_ROUND');
  static const SignaturesResponseType SIGNATURES_RESPONSE_COMPLETE = SignaturesResponseType._(2, _omitEnumNames ? '' : 'SIGNATURES_RESPONSE_COMPLETE');

  static const $core.List<SignaturesResponseType> values = <SignaturesResponseType> [
    SIGNATURES_RESPONSE_EMPTY,
    SIGNATURES_RESPONSE_NEW_ROUND,
    SIGNATURES_RESPONSE_COMPLETE,
  ];

  static final $core.Map<$core.int, SignaturesResponseType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SignaturesResponseType? valueOf($core.int value) => _byValue[value];

  const SignaturesResponseType._($core.int v, $core.String n) : super(v, n);
}

class EventType extends $pb.ProtobufEnum {
  static const EventType PARTICIPANT_STATUS_EVENT = EventType._(0, _omitEnumNames ? '' : 'PARTICIPANT_STATUS_EVENT');
  static const EventType NEW_DKG_EVENT = EventType._(1, _omitEnumNames ? '' : 'NEW_DKG_EVENT');
  static const EventType DKG_COMMITMENT_EVENT = EventType._(2, _omitEnumNames ? '' : 'DKG_COMMITMENT_EVENT');
  static const EventType DKG_REJECT_EVENT = EventType._(3, _omitEnumNames ? '' : 'DKG_REJECT_EVENT');
  static const EventType DKG_ROUND2_SHARE_EVENT = EventType._(4, _omitEnumNames ? '' : 'DKG_ROUND2_SHARE_EVENT');
  static const EventType DKG_ACK_EVENT = EventType._(5, _omitEnumNames ? '' : 'DKG_ACK_EVENT');
  static const EventType DKG_ACK_REQUEST_EVENT = EventType._(6, _omitEnumNames ? '' : 'DKG_ACK_REQUEST_EVENT');
  static const EventType SIG_REQ_EVENT = EventType._(7, _omitEnumNames ? '' : 'SIG_REQ_EVENT');
  static const EventType SIG_NEW_ROUNDS_EVENT = EventType._(8, _omitEnumNames ? '' : 'SIG_NEW_ROUNDS_EVENT');
  static const EventType SIG_COMPLETE_EVENT = EventType._(9, _omitEnumNames ? '' : 'SIG_COMPLETE_EVENT');
  static const EventType SIG_FAILURE_EVENT = EventType._(10, _omitEnumNames ? '' : 'SIG_FAILURE_EVENT');
  static const EventType KEEPALIVE_EVENT = EventType._(11, _omitEnumNames ? '' : 'KEEPALIVE_EVENT');
  static const EventType SECRET_SHARE_EVENT = EventType._(12, _omitEnumNames ? '' : 'SECRET_SHARE_EVENT');

  static const $core.List<EventType> values = <EventType> [
    PARTICIPANT_STATUS_EVENT,
    NEW_DKG_EVENT,
    DKG_COMMITMENT_EVENT,
    DKG_REJECT_EVENT,
    DKG_ROUND2_SHARE_EVENT,
    DKG_ACK_EVENT,
    DKG_ACK_REQUEST_EVENT,
    SIG_REQ_EVENT,
    SIG_NEW_ROUNDS_EVENT,
    SIG_COMPLETE_EVENT,
    SIG_FAILURE_EVENT,
    KEEPALIVE_EVENT,
    SECRET_SHARE_EVENT,
  ];

  static final $core.Map<$core.int, EventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EventType? valueOf($core.int value) => _byValue[value];

  const EventType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
