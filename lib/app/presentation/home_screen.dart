import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/presentation/components/scorecard.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/league/presentation/league_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(fetchCoursesProvider);
    final leagues = ref.watch(fetchLeaguesProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to Greenie!'),
          switch (courses) {
            AsyncData(:final value) => Scorecard(course: value.first),
            _ => Text('Loading courses...'),
          },
          switch (leagues) {
            AsyncData(:final value) => LeagueHomeScreen(league: value.first),
            _ => Text('Loading leagues...'),
          },
        ],
      ),
    );
  }
}
