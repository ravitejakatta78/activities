// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';

import 'package:publicschool_app/main.dart';
import 'package:publicschool_app/pages/sign_in/bloc/login_bloc.dart';
import 'package:publicschool_app/pages/splash/app_page.dart';



// class TestBlocMock extends Mock implements LoginBloc {}
//
// void main() {
//   testWidgets('Test', (WidgetTester tester) async {
//     final testBloc = TestBlocMock();
//
//     await tester.pumpWidget(
//         BlocProvider<LoginBloc>(bloc:LoginBloc() , child: AppPage()));
//     await tester.pump(Duration.zero);
//   });
// }