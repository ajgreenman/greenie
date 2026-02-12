// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchCourses)
const fetchCoursesProvider = FetchCoursesProvider._();

final class FetchCoursesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CourseModel>>,
          List<CourseModel>,
          FutureOr<List<CourseModel>>
        >
    with
        $FutureModifier<List<CourseModel>>,
        $FutureProvider<List<CourseModel>> {
  const FetchCoursesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchCoursesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchCoursesHash();

  @$internal
  @override
  $FutureProviderElement<List<CourseModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CourseModel>> create(Ref ref) {
    return fetchCourses(ref);
  }
}

String _$fetchCoursesHash() => r'b5645f23b2b9b2be92119e02692a2c31c4bce7e0';

@ProviderFor(fetchCourse)
const fetchCourseProvider = FetchCourseFamily._();

final class FetchCourseProvider
    extends
        $FunctionalProvider<
          AsyncValue<CourseModel?>,
          CourseModel?,
          FutureOr<CourseModel?>
        >
    with $FutureModifier<CourseModel?>, $FutureProvider<CourseModel?> {
  const FetchCourseProvider._({
    required FetchCourseFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchCourseProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchCourseHash();

  @override
  String toString() {
    return r'fetchCourseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CourseModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CourseModel?> create(Ref ref) {
    final argument = this.argument as String;
    return fetchCourse(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCourseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchCourseHash() => r'0ba0d1fa642d2bbba5505989867ea9204ec9e142';

final class FetchCourseFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CourseModel?>, String> {
  const FetchCourseFamily._()
    : super(
        retry: null,
        name: r'fetchCourseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchCourseProvider call(String courseId) =>
      FetchCourseProvider._(argument: courseId, from: this);

  @override
  String toString() => r'fetchCourseProvider';
}
