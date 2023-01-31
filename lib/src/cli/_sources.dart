// FILE GENERATED BY scripts/update-cli.sh - DO NOT MODIFY BY HAND

import 'package:sentry_dart_plugin/src/cli/sources.dart';

import 'host_platform.dart';

const _version = '2.12.0';
const _urlPrefix = 'https://downloads.sentry-cdn.com/sentry-cli/$_version';

final currentCLISources = {
  HostPlatform.darwinUniversal: CLISource(
      '$_urlPrefix/sentry-cli-Darwin-universal',
      'b78bb9a567d379577091cfc860af0ad3734b694cc338c042ade7ba57ad0b34b5'),
  HostPlatform.linuxAarch64: CLISource('$_urlPrefix/sentry-cli-Linux-aarch64',
      '4b9e88a1925dd09c706c2263d2d671682bc4b2f146f2ee12670ec7fe6cd51f1d'),
  HostPlatform.linuxArmv7: CLISource('$_urlPrefix/sentry-cli-Linux-armv7',
      'e30a93193d24d518e6483e930d0e099f995702030cc50a26bdecc62c1f3c5c4e'),
  HostPlatform.linux64bit: CLISource('$_urlPrefix/sentry-cli-Linux-x86_64',
      'ab6723a84675bc7d11bbf4f723511150af0c58e10c1c1dafb8210837d2a97673'),
  HostPlatform.windows32bit: CLISource(
      '$_urlPrefix/sentry-cli-Windows-i686.exe',
      'bf90b9a411f9cef7cfce72cfe4a24595b4fbc125e40fb67eaaa702cfc4d347d0'),
  HostPlatform.windows64bit: CLISource(
      '$_urlPrefix/sentry-cli-Windows-x86_64.exe',
      '138d3cd500d69a07b0548f15d297139c5f0d6604c4c806b54596abe14895bdf2'),
};
