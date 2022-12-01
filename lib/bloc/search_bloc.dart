import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testingrxdart_course/bloc/api.dart';
import 'package:testingrxdart_course/bloc/search_result.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();
    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchterm) {
      //Switch map untuk mengalirkan ke stream
      if (searchterm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        //final foo = <= untuk cek apabila di map dia akan bisa diakses
        final foo = Rx.fromCallable(() => api.search(searchterm))
            .delay(const Duration(seconds: 1)) //untuk fake latency
            .map(
              (results) => results.isEmpty
                  ? const SearchResultNoResult()
                  : SearchResultWithResults(results),
            )
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasErrror(error));
        return foo;
      }
    });

    return SearchBloc._(search: textChanges.sink, results: results);
  }
  const SearchBloc._({required this.search, required this.results});
}
