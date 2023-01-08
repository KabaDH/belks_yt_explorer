import 'package:belks_tube/data/repo/remote/http/dio_provider.dart';
import 'package:belks_tube/data/repo/remote/http/rest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@riverpod
RestClient apiClient(ApiClientRef ref) => RestClient(ref.read(dioProvider));
