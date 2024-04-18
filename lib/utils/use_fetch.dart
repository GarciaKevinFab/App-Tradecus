import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef FetchDataCallback = Future<dynamic> Function(dynamic);

class UseFetch<T> {
  final String url;
  final FetchDataCallback fetchDataCallback;

  UseFetch({required this.url, required this.fetchDataCallback});

  Future<Map<String, dynamic>> fetch() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = await json.decode(response.body);
        return result;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<T> fetchData() async {
    try {
      final result = await fetch();
      final data = await fetchDataCallback(result) as T;
      return data;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}

class UseFetchProvider<T> extends StatefulWidget {
  final String url;
  final FetchDataCallback fetchDataCallback;
  final Widget Function(BuildContext context, UseFetch<T> useFetch) builder;

  UseFetchProvider({
    required this.url,
    required this.fetchDataCallback,
    required this.builder,
  });

  @override
  _UseFetchProviderState<T> createState() => _UseFetchProviderState<T>();
}

class _UseFetchProviderState<T> extends State<UseFetchProvider<T>> {
  late UseFetch<T> _useFetch;

  @override
  void initState() {
    super.initState();
    _useFetch = UseFetch<T>(
      url: widget.url,
      fetchDataCallback: widget.fetchDataCallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _useFetch);
  }
}
