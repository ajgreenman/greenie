// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel>,
          UserModel,
          FutureOr<UserModel>
        >
    with $FutureModifier<UserModel>, $FutureProvider<UserModel> {
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<UserModel> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'c716ff15570e2c24949af664a80711f7768e5239';

@ProviderFor(fetchMembers)
const fetchMembersProvider = FetchMembersFamily._();

final class FetchMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberModel>>,
          List<MemberModel>,
          FutureOr<List<MemberModel>>
        >
    with
        $FutureModifier<List<MemberModel>>,
        $FutureProvider<List<MemberModel>> {
  const FetchMembersProvider._({
    required FetchMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchMembersHash();

  @override
  String toString() {
    return r'fetchMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemberModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemberModel>> create(Ref ref) {
    final argument = this.argument as String;
    return fetchMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchMembersHash() => r'28f02909941db4a8a340e2d37dbc4ac5a478b8f7';

final class FetchMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MemberModel>>, String> {
  const FetchMembersFamily._()
    : super(
        retry: null,
        name: r'fetchMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchMembersProvider call(String leagueId) =>
      FetchMembersProvider._(argument: leagueId, from: this);

  @override
  String toString() => r'fetchMembersProvider';
}
