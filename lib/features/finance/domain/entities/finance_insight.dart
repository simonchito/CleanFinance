enum FinanceInsightTone { positive, warning, neutral }

class FinanceInsight {
  const FinanceInsight({
    required this.title,
    required this.message,
    required this.tone,
  });

  final String title;
  final String message;
  final FinanceInsightTone tone;
}
