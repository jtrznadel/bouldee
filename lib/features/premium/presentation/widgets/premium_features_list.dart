import 'package:bouldee/features/premium/presentation/widgets/premium_feature_tile.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PremiumFeaturesList extends StatelessWidget {
  const PremiumFeaturesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 12,
      children: [
        PremiumFeatureTile(
          title: 'Zaawansowana analiza',
          description:
              'Szczegółowe statystyki i wizualizacje Twoich treningów, postępów i wzorców wspinaczkowych.',
          icon: LucideIcons.chartNetwork,
        ),
        PremiumFeatureTile(
          title: 'Spersonalizowane plany treningowe',
          description:
              'Plany treningowe dostosowane do Twoich celów, poziomu umiejętności i dostępnego czasu.',
          icon: LucideIcons.notebookText,
        ),
        PremiumFeatureTile(
          title: 'Podpowiedzi i rozwiązania problemów',
          description:
              'Dostęp do bazy danych z podpowiedziami i rozwiązaniami problemów wspinaczkowych.',
          icon: LucideIcons.lightbulb,
        ),
      ],
    );
  }
}
