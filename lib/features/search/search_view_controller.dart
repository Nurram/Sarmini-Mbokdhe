import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/suggestion_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class SearchViewController extends BaseController {
  final serachNode = FocusNode();

  final suggestions = <SuggestionDatum>[].obs;

  getSuggestions({required String q}) async {
    try {
      if (q.length > 2) {
        final suggestionsResponse =
            await ApiProvider().post(endpoint: '/suggestions', body: {'q': q});
        final suggestion = SuggestionResponse.fromJson(suggestionsResponse);

        suggestions(suggestion.data);
      } else {
        suggestions.clear();
      }
    } catch (e) {
      Utils.showGetSnackbar(e.toString(), true);
    }
  }
}
