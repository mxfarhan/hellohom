import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generateClientToken(String merchantId, String publicKey, String privateKey) async {
  final url = 'https://api.braintreegateway.com/merchants/$merchantId/client_token';
  final credentials = '$publicKey:$privateKey';
  final base64Credentials = base64Encode(utf8.encode(credentials));

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic $base64Credentials',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['clientToken'];
    } else {
      throw Exception('Failed to generate client token. Status code: ${response.statusCode}. Response body: ${response.body}');
    }
  } catch (e) {
    print('Exception caught: $e');
    rethrow;
  }
}
