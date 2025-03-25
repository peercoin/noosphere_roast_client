import 'dart:io';
import 'package:args/args.dart';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart' as fr;
import 'package:noosphere_roast_client/noosphere_roast_client.dart' as ns;
import 'package:grpc/grpc.dart';

/// Logs into an **insecure** server using `--config`, `--host`, `--port` and
/// `--key`, requests a DKG and prints every time an event is produced by the
/// client.
void main(List<String> args) async {

  await fr.loadFrosty();

  final argParser = ArgParser()..addOption(
    "config",
    abbr: "c",
    help: "The path to the ClientConfig YAML file",
    mandatory: true,
  )..addOption(
    "host",
    abbr: "h",
    help: "The hostname of the server",
    mandatory: true,
  )..addOption(
    "port",
    abbr: "p",
    help: "The port of the server",
    mandatory: true,
  )..addOption(
    "key",
    abbr: "k",
    help: "The hex of the private key for the client",
    mandatory: true,
  );
  final argResults = argParser.parse(args);
  final configFile = argResults.option("config")!;
  final configString = File(configFile).readAsStringSync();
  final host = argResults.option("host")!;
  final port = int.parse(argResults.option("port")!);
  final key = cl.ECPrivateKey.fromHex(argResults.option("key")!);

  final client = await ns.Client.login(
    config: ns.ClientConfig.fromYaml(configString),
    api: ns.GrpcClientApi(
      ClientChannel(
        host,
        port: port,
        options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    ),
    store: ns.InMemoryClientStorage(),
    getPrivateKey: (_) async => key,
    onDisconnect: () => print("Disconnected Callback"),
  );
  print("Logged in");

  await client.requestDkg(
    ns.NewDkgDetails(
      name: "Example DKG ${cl.bytesToHex(cl.generateRandomBytes(4))}",
      description: "A DKG request for example purposes",
      threshold: 2,
      expiry: ns.Expiry(Duration(hours: 1)),
    ),
  );

  await for (final event in client.events) {
    print(event);
  }

  print("Logged out / Disconnected");

}
