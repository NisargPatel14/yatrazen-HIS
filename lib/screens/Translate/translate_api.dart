// translation_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchTranslation(String text,
    {required String fromLanguage, required String toLanguage}) async {
  const apiUrl = 'https://t.song.work/api';

  final params = {
    'text': text,
    'from': fromLanguage,
    'to': toLanguage,
  };

  final uri = Uri.parse('$apiUrl?${encodeParams(params)}');

  final response = await http.get(uri);

  // Check if the response status code is successful (status code 200)
}

String encodeParams(Map<String, String> params) {
  return params.entries
      .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
      .join('&');
}
