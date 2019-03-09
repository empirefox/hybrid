import 'package:test_api/test_api.dart';
import 'package:hybrid/src/protos.dart';

main() {
  test('fields should be strings of int', () {
    expect(int.tryParse(ConfigFields.basic) != null, true);
  });

  test('getField should be ok', () {
    final pb = Basic()..flushIntervalMs = 10;
    var tagNumber = int.parse(BasicFields.flush_interval_ms);
    expect(pb.getField(tagNumber), 10);
    tagNumber = int.parse(BasicFields.token);
    expect(pb.getField(tagNumber), '');

    final config = Config();
    tagNumber = int.parse(ConfigFields.basic);
    expect(config.getField(tagNumber), Basic());
  });

  test('pb2map should use proto tag numbers', () {
    final pb = Basic()..flushIntervalMs = 10;
    final pbmap = pb.writeToJsonMap();
    expect(pbmap[BasicFields.flush_interval_ms], 10);
  });
}
