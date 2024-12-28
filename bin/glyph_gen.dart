import 'package:args/args.dart';
import 'package:glyph_gen/src/core/glyph_gen.dart';

const String version = '0.0.1';

Future<void> main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  final ArgResults results;

  try {
    results = argParser.parse(arguments);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print('${e.message}\n');
    printUsage(argParser);
    return;
  }

  // If there are no arguments, print usage information.
  if (results.arguments.isEmpty || results.arguments.length == 1 && results['verbose']) {
    printUsage(argParser);
    return;
  }

  final optionsFromArgs = handleArgResults(argParser, results);

  if (optionsFromArgs == null) {
    return;
  }
}

void printUsage(ArgParser argParser) {
  print('Usage: dart glyph_gen.dart <flags> [arguments]');
  print(argParser.usage);
}

/// Handles the results of the parsed arguments.
///
/// Returns a [GlyphGenOptions] object if the arguments are valid.
///
/// If this returns `null`, the program should exit.
GlyphGenOptions? handleArgResults(ArgParser argParser, ArgResults results) {
  if (results['help']) {
    printUsage(argParser);
    return null;
  }

  if (results['version']) {
    print('Version: $version');
    return null;
  }

  final String inputDirectory = results['input'];
  final String? outputFontDirectory = results['output-font'];
  final String? outputDartDirectory = results['output-dart'];
  final bool recursive = results['recursive'];
  final bool verbose = results['verbose'];

  print('Input directory: $inputDirectory');
  print('Output font directory: $outputFontDirectory');
  print('Output Dart directory: $outputDartDirectory');
  print('Recursive: $recursive');
  print('Verbose: $verbose');

  return GlyphGenOptions(
    inputDirectory: inputDirectory,
    outputFontDirectory: outputFontDirectory,
    outputDartDirectory: outputDartDirectory,
    recursive: recursive,
    verbose: verbose,
  );
}

/// {@template glyph_gen_options}
/// Options for glyph_gen CLI tool.
/// {@endtemplate}
class GlyphGenOptions {
  /// {@macro glyph_gen_options}
  GlyphGenOptions({
    this.inputDirectory,
    this.recursive = true,
    this.outputFontDirectory,
    this.outputDartDirectory,
    this.verbose = false,
  });

  /// The directory containing the input SVG files.
  final String? inputDirectory;

  /// Whether to get the input files recursively from [inputDirectory].
  final bool recursive;

  /// The directory where the generated font file will be saved.
  final String? outputFontDirectory;

  /// The directory where the generated Dart file will be saved.
  final String? outputDartDirectory;

  /// Whether to print verbose output.
  final bool verbose;

  /// Returns a new [GlyphGenOptions] object with updated fields.
  GlyphGenOptions copyWith({
    String? inputDirectory,
    bool? recursive,
    String? outputFontDirectory,
    String? outputDartDirectory,
    bool? verbose,
  }) {
    return GlyphGenOptions(
      inputDirectory: inputDirectory ?? this.inputDirectory,
      recursive: recursive ?? this.recursive,
      outputFontDirectory: outputFontDirectory ?? this.outputFontDirectory,
      outputDartDirectory: outputDartDirectory ?? this.outputDartDirectory,
      verbose: verbose ?? this.verbose,
    );
  }
}

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      defaultsTo: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addOption(
      'input',
      abbr: 'i',
      help: 'The directory containing the input SVG files.',
    )
    ..addOption(
      'output-font',
      abbr: 'f',
      help: 'The directory where the generated font file will be saved.',
    )
    ..addOption(
      'output-dart',
      abbr: 'd',
      help: 'The directory where the generated Dart file will be saved.',
    )
    ..addFlag(
      'recursive',
      abbr: 'r',
      defaultsTo: true,
      negatable: false,
      help: 'Whether to get the input files recursively from the input directory.',
    );
}
