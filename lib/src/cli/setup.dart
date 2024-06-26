import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:file/file.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_dart_plugin/src/utils/injector.dart';

import '../utils/log.dart';
import 'host_platform.dart';
import 'sources.dart';

class CLISetup {
  final /*CLISources*/ Map<HostPlatform, CLISource> _sources;

  CLISetup(this._sources);

  Future<String> download(
    HostPlatform platform,
    String directory,
    String downloadUrlPrefix,
    String? versionOverride,
  ) async {
    final dir = injector.get<FileSystem>().directory(directory);
    await dir.create(recursive: true);
    final file = dir.childFile('sentry-cli${platform.executableExtension}');

    final source = _sources[platform]!;

    if (!await _check(source, file, versionOverride)) {
      await _download(source, file, downloadUrlPrefix, versionOverride);
    }

    return file.path;
  }

  Future<void> check(
    HostPlatform platform,
    String path,
    String downloadUrlPrefix,
    String? versionOverride,
  ) async {
    final file = injector.get<FileSystem>().file(path);
    final source = _sources[platform]!;
    if (!await _check(source, file, versionOverride)) {
      final downloadUrl =
          source.formatDownloadUrl(downloadUrlPrefix, versionOverride);
      Log.warn(
          "Download Sentry CLI ${versionOverride ?? source.version} from '$downloadUrl' and update at path '${file.path}'.");
    }
  }

  Future<void> _download(CLISource source, File file, String downloadUrlPrefix,
      String? versionOverride) async {
    final downloadUrl =
        source.formatDownloadUrl(downloadUrlPrefix, versionOverride);
    Log.info(
        "Downloading Sentry CLI ${versionOverride ?? source.version} from $downloadUrl to ${file.path}");

    final client = http.Client();
    try {
      final response = await client.send(http.Request('GET', downloadUrl));
      final sink = file.openWrite();
      await sink.addStream(response.stream);
      await sink.close();
    } finally {
      client.close();
    }

    if (await _check(source, file, versionOverride)) {
      Log.info("Sentry CLI downloaded successfully.");
    } else {
      Log.error(
          "Failed to download Sentry CLI: downloaded file doesn't match the expected checksum.");
    }
  }

  Future<bool> _check(
      CLISource source, File file, String? versionOverride) async {
    if (!await file.exists()) {
      return false;
    }
    if (versionOverride != null) {
      Log.info(
          "Sentry CLI binary checksum verification skipped due to version override.");
      return true;
    }

    final calculated = await _hash(file);
    final expected = source.hash;
    if (calculated != expected) {
      Log.warn(
          "Sentry CLI checksum mismatch on ${file.path} - expected $expected but got $calculated.");
      return false;
    }

    Log.info(
        "Sentry CLI binary checksum verification passed successfully (hash: $calculated).");
    return true;
  }

  Future<String> _hash(File file) async {
    var output = AccumulatorSink<Digest>();
    var input = sha256.startChunkedConversion(output);
    final stream = file.openRead();
    await for (final chunk in stream) {
      input.add(chunk);
    }
    input.close();
    return output.events.single.toString();
  }
}
