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
