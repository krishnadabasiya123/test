import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {'hello': 'Hello World', 'change_lang': 'Change Language', 'title': 'Home Page'},
    'hi_IN': {'hello': 'नमस्ते दुनिया', 'change_lang': 'भाषा बदलें', 'title': 'मुख्य पृष्ठ'},
    'fr_FR': {'hello': 'Bonjour le monde', 'change_lang': 'Changer la langue', 'title': 'Page d\'accueil'},
  };
}
