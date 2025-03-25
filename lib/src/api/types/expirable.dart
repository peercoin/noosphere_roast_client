import 'package:noosphere_roast_client/src/api/types/expiry.dart';

abstract interface class Expirable {
  Expiry get expiry;
}

/// An implementation of [Expirable] that merely provides the expiry and nothing
/// else.
final class FinalExpirable implements Expirable {
  @override
  final Expiry expiry;
  FinalExpirable(this.expiry);
}
