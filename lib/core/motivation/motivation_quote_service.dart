import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MotivationQuote {
  const MotivationQuote({required this.text, required this.author});

  final String text;
  final String author;
}

class MotivationQuoteService {
  const MotivationQuoteService();

  static const fallback = MotivationQuote(
      text: 'A little progress every day leads to big results!',
      author: 'RoutineBunny');

  Future<MotivationQuote> fetch() async {
    try {
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/today'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode != 200) return fallback;
      final payload = jsonDecode(response.body);
      if (payload is! List || payload.isEmpty || payload.first is! Map)
        return fallback;
      final quote = payload.first['q']?.toString().trim();
      final author = payload.first['a']?.toString().trim();
      if (quote == null || quote.isEmpty) return fallback;
      return MotivationQuote(
          text: quote,
          author:
              author == null || author.isEmpty ? 'A little reminder' : author);
    } catch (_) {
      return fallback;
    }
  }
}

final motivationQuoteServiceProvider =
    Provider<MotivationQuoteService>((ref) => const MotivationQuoteService());
final motivationQuoteProvider = FutureProvider<MotivationQuote>(
    (ref) => ref.watch(motivationQuoteServiceProvider).fetch());
