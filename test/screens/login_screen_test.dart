import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:lanchonete/screens/login_screen.dart';
import 'package:lanchonete/services/auth_service.dart';
import 'package:lanchonete/models/user.dart';

@GenerateMocks([AuthService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('LoginScreen shows login form', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('LoginScreen handles successful login',
      (WidgetTester tester) async {
    const email = 'test@example.com';
    const password = 'password123';

    when(mockAuthService.login(
      email: email,
      password: password,
    )).thenAnswer((_) async => User(
          email: email,
          name: 'Test User',
          token: 'test-token',
        ));

    await tester.pumpWidget(
      MaterialApp(
        home: Provider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
        routes: {
          '/products': (context) => const Scaffold(body: Text('Products Screen')),
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, email);
    await tester.enterText(find.byType(TextFormField).last, password);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Products Screen'), findsOneWidget);
  });

  testWidgets('LoginScreen handles login failure',
      (WidgetTester tester) async {
    when(mockAuthService.login(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(Exception('Invalid credentials'));

    await tester.pumpWidget(
      MaterialApp(
        home: Provider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(
        find.byType(TextFormField).last, 'wrong-password');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('LoginScreen validates empty fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
