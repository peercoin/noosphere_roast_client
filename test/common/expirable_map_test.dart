import 'package:noosphere_roast_client/noosphere_roast_client.dart';
import 'package:noosphere_roast_client/src/common/expirable_map.dart';
import 'package:test/test.dart';

class TestExpirable implements Expirable {
  bool expired;
  TestExpirable(this.expired);
  @override
  Expiry get expiry => Expiry(Duration(days: expired ? -1 : 1));
}

void main() {

  setUpAll(loadFrosty);

  group("ExpirableMap", () {

    test("adds one of each and removes when expired", () {

      List<int> expired = [];

      late final ExpirableMap<int, TestExpirable> map;
      map = ExpirableMap(
        onExpired: (k, v) {
          expired.add(k);
          // Ensure access in callback doesn't break it
          map[1];
        },
      );

      // Add 1 twice, keeping only 1
      map[1] = TestExpirable(false);
      map[1] = TestExpirable(false);

      // Add 2 but expired on second time
      map[2] = TestExpirable(false);
      map[2] = TestExpirable(true);

      // Add 3 to give 2 in total
      map[3] = TestExpirable(true);
      map[3] = TestExpirable(false);

      expect(map[1], isA<TestExpirable>());
      expect(map[2], null);
      expect(map[3], isA<TestExpirable>());
      expect(map[4], null);

      // Expire 1
      map[1]!.expired = true;
      expect(map[1], null);

      // Remove 3
      map.remove(3);
      expect(map[3], null);

      expect(expired, [2, 3, 1]);

    });

  });

}

