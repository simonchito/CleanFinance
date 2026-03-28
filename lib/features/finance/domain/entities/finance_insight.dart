enum FinanceInsightTone { positive, warning, neutral }
enum FinanceInsightKind { descriptive, diagnostic, predictive, actionable }

class FinanceInsight {
  const FinanceInsight({
    required this.title,
    required this.message,
    required this.tone,
    required this.kind,
  });

  final String title;
  final String message;
  final FinanceInsightTone tone;
  final FinanceInsightKind kind;
}
