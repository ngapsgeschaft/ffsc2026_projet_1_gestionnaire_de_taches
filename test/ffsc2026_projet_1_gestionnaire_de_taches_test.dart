import 'package:ffsc2026_projet_1_gestionnaire_de_taches/ffsc2026_projet_1_gestionnaire_de_taches.dart';
import 'package:test/test.dart';

void main() {
  test('Throw an exception for invalid choice', () {
    expect(() => getUserChoice('invalid'), throwsA(isA<ChoiceException>()));
  });
}
