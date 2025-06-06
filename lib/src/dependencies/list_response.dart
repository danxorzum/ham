import 'package:ham/src/core/defs/defs.dart';

///{@template list_response}
/// Class to catch list http response.
/// {@endtemplate}
@Deprecated('This isnt ham property, so do not use anymore')
class ListResponse<T> {
  ///{@macro list_response}
  factory ListResponse.fromJson({
    required Json json,
    required T Function(Json) fromJson,
    required String key,
  }) => ListResponse._(
    list: ((json['data'] as Json)[key] as List)
        .map((e) => fromJson(e as Json))
        .toList(),
  );

  const ListResponse._({required this.list});

  /// List of items
  final List<T> list;
}
