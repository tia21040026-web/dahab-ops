// Regenerates lib/core/design/tokens.g.dart from the web design tokens.
//
//   fvm dart run tool/gen_tokens.dart [path/to/tokens.css]
//
// Source of truth: ../src/styles/tokens.css (Granite & Lagoon). The script
// reads the theme-independent `:root` scale block and the three theme blocks
// (abyss, salt, high-contrast-pro). Destination overrides (nuweiba/siwa),
// shadows, legacy variables and media queries are deliberately ignored: the
// staff app has one place and no shadows.
// ignore_for_file: avoid_print
import 'dart:io';

const _themes = {
  'abyss': 'Abyss',
  'salt': 'Salt',
  'high-contrast-pro': 'HighContrastPro',
};

void main(List<String> args) {
  final source = args.isNotEmpty ? args.first : '../src/styles/tokens.css';
  final file = File(source);
  if (!file.existsSync()) {
    stderr.writeln('tokens.css not found at $source');
    exit(64);
  }
  final css = _stripComments(file.readAsStringSync());
  final blocks = _blocks(css);

  final scale = <String, String>{};
  final themes = <String, Map<String, String>>{};
  for (final b in blocks) {
    final sel = b.selector.trim();
    if (sel.contains('data-destination') || sel.startsWith('@')) continue;
    if (sel == ':root') {
      scale.addAll(b.vars);
      continue;
    }
    for (final id in _themes.keys) {
      if (sel.contains('data-theme-id="$id"')) {
        themes.putIfAbsent(id, () => {}).addAll(b.vars);
      }
    }
  }

  String resolve(String value, Map<String, String> scope) {
    var v = value.trim();
    for (var i = 0; i < 8; i++) {
      final m = RegExp(r'^var\((--[\w-]+)\)$').firstMatch(v);
      if (m == null) break;
      v = (scope[m.group(1)] ?? scale[m.group(1)] ?? v).trim();
    }
    return v;
  }

  final out = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Source: src/styles/tokens.css via tool/gen_tokens.dart.')
    ..writeln('// Regenerate: fvm dart run tool/gen_tokens.dart')
    ..writeln('// ignore_for_file: constant_identifier_names')
    ..writeln()
    ..writeln("import 'package:flutter/painting.dart';")
    ..writeln()
    ..writeln('/// Theme-independent scales (spacing, radii, type, motion, geometry).')
    ..writeln('abstract final class DgScale {');
  final scaleKeys = scale.keys.where((k) => k.startsWith('--dg-')).toList();
  for (final key in scaleKeys) {
    final name = _camel(key.substring(5));
    final raw = resolve(scale[key]!, scale);
    final color = _color(raw);
    if (color != null) {
      out.writeln('  static const Color $name = $color;');
      continue;
    }
    final px = RegExp(r'^(-?[\d.]+)px$').firstMatch(raw);
    final rem = RegExp(r'^(-?[\d.]+)rem$').firstMatch(raw);
    final ms = RegExp(r'^(\d+)ms$').firstMatch(raw);
    final bezier = RegExp(r'^cubic-bezier\(([^)]+)\)$').firstMatch(raw);
    if (px != null) {
      out.writeln('  static const double $name = ${_num(double.parse(px.group(1)!))};');
    } else if (rem != null) {
      out.writeln('  static const double $name = ${_num(double.parse(rem.group(1)!) * 16)};');
    } else if (ms != null) {
      out.writeln('  static const Duration $name = Duration(milliseconds: ${ms.group(1)});');
    } else if (bezier != null) {
      final p = bezier.group(1)!.split(',').map((e) => e.trim()).join(', ');
      out.writeln('  static const List<double> $name = [$p];');
    } else if (RegExp(r'^-?\d+$').hasMatch(raw)) {
      out.writeln('  static const int $name = $raw;');
    }
  }
  out.writeln('}');

  for (final entry in _themes.entries) {
    final vars = themes[entry.key] ?? const {};
    out
      ..writeln()
      ..writeln('/// `${entry.key}` theme colours.')
      ..writeln('abstract final class Dg${entry.value} {');
    for (final key in vars.keys.where((k) => k.startsWith('--dg-'))) {
      final color = _color(resolve(vars[key]!, vars));
      if (color == null) continue;
      out.writeln('  static const Color ${_camel(key.substring(5))} = $color;');
    }
    out.writeln('}');
  }

  final target = File('lib/core/design/tokens.g.dart');
  target.createSync(recursive: true);
  target.writeAsStringSync(out.toString());
  print('Wrote ${target.path}: ${scaleKeys.length} scale tokens, '
      '${themes.length} themes.');
}

class _Block {
  _Block(this.selector, this.vars);
  final String selector;
  final Map<String, String> vars;
}

String _stripComments(String css) =>
    css.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');

/// Top-level `selector { body }` blocks. Nested blocks (media queries)
/// are returned with their at-rule selector so the caller can skip them.
List<_Block> _blocks(String css) {
  final result = <_Block>[];
  var depth = 0;
  var start = 0;
  var bodyStart = 0;
  String? selector;
  for (var i = 0; i < css.length; i++) {
    final c = css[i];
    if (c == '{') {
      if (depth == 0) {
        selector = css.substring(start, i);
        bodyStart = i + 1;
      }
      depth++;
    } else if (c == '}') {
      depth--;
      if (depth == 0 && selector != null) {
        final body = css.substring(bodyStart, i);
        final vars = <String, String>{};
        for (final m in RegExp(r'(--[\w-]+)\s*:\s*([^;]+);').allMatches(body)) {
          vars[m.group(1)!] = m.group(2)!.trim();
        }
        result.add(_Block(selector, vars));
        selector = null;
        start = i + 1;
      }
    }
  }
  return result;
}

String _camel(String kebab) {
  final parts = kebab.split('-');
  return parts.first +
      parts.skip(1).map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1)).join();
}

String _num(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

String? _color(String raw) {
  final v = raw.trim();
  final hex = RegExp(r'^#([0-9a-fA-F]{6})$').firstMatch(v);
  if (hex != null) return 'Color(0xFF${hex.group(1)!.toUpperCase()})';
  final rgba = RegExp(r'^rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+)\s*)?\)$')
      .firstMatch(v);
  if (rgba != null) {
    final a = rgba.group(4) == null ? 1.0 : double.parse(rgba.group(4)!);
    String h(int n) => n.toRadixString(16).padLeft(2, '0').toUpperCase();
    final alpha = (a * 255).round();
    return 'Color(0x${h(alpha)}${h(int.parse(rgba.group(1)!))}'
        '${h(int.parse(rgba.group(2)!))}${h(int.parse(rgba.group(3)!))})';
  }
  if (v == 'transparent') return 'Color(0x00000000)';
  return null;
}
