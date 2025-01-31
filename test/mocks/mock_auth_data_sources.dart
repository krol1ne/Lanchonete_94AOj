import 'package:mockito/mockito.dart';
import '../../lib/data/datasources/auth_local_data_source.dart';
import '../../lib/data/datasources/auth_remote_data_source.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
