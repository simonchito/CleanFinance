import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../widgets/section_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final sections = _buildSections(strings);

    return Scaffold(
      appBar: AppBar(title: Text(strings.privacyPolicy)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ...section.paragraphs.map(
                  (paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SelectableText(
                      paragraph,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_PolicySection> _buildSections(AppStrings strings) {
    return [
      _PolicySection(
        title: strings.privacySummaryTitle,
        paragraphs: [
          strings.privacySummaryBody1,
          strings.privacySummaryBody2,
        ],
      ),
      _PolicySection(
        title: strings.privacyStoredDataTitle,
        paragraphs: [
          strings.privacyStoredDataBody1,
          strings.privacyStoredDataBody2,
        ],
      ),
      _PolicySection(
        title: strings.privacyBiometricsTitle,
        paragraphs: [
          strings.privacyBiometricsBody1,
          strings.privacyBiometricsBody2,
        ],
      ),
      _PolicySection(
        title: strings.privacyBackupsTitle,
        paragraphs: [
          strings.privacyBackupsBody1,
          strings.privacyBackupsBody2,
        ],
      ),
      _PolicySection(
        title: strings.privacySharingTitle,
        paragraphs: [
          strings.privacySharingBody1,
          strings.privacySharingBody2,
        ],
      ),
      _PolicySection(
        title: strings.privacySecurityTitle,
        paragraphs: [
          strings.privacySecurityBody1,
          strings.privacySecurityBody2,
        ],
      ),
      _PolicySection(
        title: strings.privacyContactTitle,
        paragraphs: [
          strings.privacyContactBody1,
        ],
      ),
    ];
  }
}

class _PolicySection {
  const _PolicySection({
    required this.title,
    required this.paragraphs,
  });

  final String title;
  final List<String> paragraphs;
}
