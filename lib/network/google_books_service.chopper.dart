// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_books_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$GoogleBooksService extends GoogleBooksService {
  _$GoogleBooksService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = GoogleBooksService;

  @override
  Future<Response<Result<Book>>> queryBook(String id) {
    final Uri $url = Uri.parse('volumes/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Result<Book>, Book>($request);
  }

  @override
  Future<Response<Result<QueryResult>>> queryBooks(
    String query,
    int offset,
    int number,
  ) {
    final Uri $url = Uri.parse('volumes');
    final Map<String, dynamic> $params = <String, dynamic>{
      'q': query,
      'startIndex': offset,
      'maxResults': number,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Result<QueryResult>, QueryResult>($request);
  }
}
