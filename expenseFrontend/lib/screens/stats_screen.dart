import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../services/expense_service.dart';

class StatsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const StatsScreen({super.key, this.onBack});

  final List<Color> _categoryColors = AppColors.chartColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black87,
          onPressed: onBack,
        ),
        title: const Text(
          'Statistiques',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE5E5E5), height: 0.5),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ExpenseService().getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur lors du chargement des données: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          final expenses = snapshot.data ?? [];

          if (expenses.isEmpty) {
            return const Center(
              child: Text(
                'Aucune donnée de dépense disponible.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            );
          }

          // 1. Calcul dynamique du total par catégorie
          final Map<String, double> categoryTotals = {};
          for (var e in expenses) {
            categoryTotals[e.categorie] = (categoryTotals[e.categorie] ?? 0) + e.montant;
          }

          final double total = expenses.fold(0.0, (sum, e) => sum + e.montant);
          final double moyenne = expenses.isEmpty ? 0 : total / expenses.length;
          final double plusHaute = expenses.isEmpty
              ? 0
              : expenses.map((e) => e.montant as double).reduce((a, b) => a > b ? a : b);
          final int categoryCount = categoryTotals.length;

          final List<MapEntry<String, double>> sortedCategories =
              categoryTotals.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

          // 2. Calcul dynamique des 6 derniers mois pour le LineChart
          final DateTime now = DateTime.now();
          final List<String> monthLabels = [];
          final List<double> monthlyData = [];

          for (int i = 5; i >= 0; i--) {
            final DateTime monthDate = DateTime(now.year, now.month - i, 1);
            final String label = DateFormat('MMM', 'fr').format(monthDate);
            monthLabels.add(label);

            final double monthTotal = expenses
                .where((e) =>
                    e.date.year == monthDate.year && e.date.month == monthDate.month)
                .fold(0.0, (sum, e) => sum + e.montant);

            monthlyData.add(monthTotal);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Carte Total ──
                _TotalCard(total: total),
                const SizedBox(height: 12),

                // ── Métriques rapides ──
                _MetricsRow(
                  moyenne: moyenne,
                  plusHaute: plusHaute,
                  categoryCount: categoryCount,
                ),
                const SizedBox(height: 12),

                // ── Donut + Légende ──
                if (sortedCategories.isNotEmpty) ...[
                  _DonutCard(
                    categoryTotals: sortedCategories,
                    total: total,
                    colors: _categoryColors,
                  ),
                  const SizedBox(height: 12),

                  // ── Barres horizontales ──
                  _BarsCard(
                    categoryTotals: sortedCategories,
                    total: total,
                    colors: _categoryColors,
                  ),
                  const SizedBox(height: 12),
                ],

                // ── Évolution mensuelle ──
                _LineChartCard(
                  monthlyData: monthlyData,
                  monthLabels: monthLabels,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total des dépenses',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF888780),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatAmount(total)} FCFA',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE24B4A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Mois en cours',
            style: TextStyle(fontSize: 12, color: Color(0xFFB4B2A9)),
          ),
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({
    required this.moyenne,
    required this.plusHaute,
    required this.categoryCount,
  });
  final double moyenne;
  final double plusHaute;
  final int categoryCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Moyenne',
            value: _formatAmount(moyenne),
            unit: 'FCFA',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            label: 'Plus haute',
            value: _formatAmount(plusHaute),
            unit: 'FCFA',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            label: 'Catégories',
            value: categoryCount.toString(),
            unit: 'actives',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
  });
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF888780)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 10, color: Color(0xFFB4B2A9)),
          ),
        ],
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({
    required this.categoryTotals,
    required this.total,
    required this.colors,
  });
  final List<MapEntry<String, double>> categoryTotals;
  final double total;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Répartition par catégorie',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF888780),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: List.generate(categoryTotals.length, (i) {
                          return PieChartSectionData(
                            color: colors[i % colors.length],
                            value: categoryTotals[i].value,
                            title: '',
                            radius: 38,
                          );
                        }),
                        sectionsSpace: 2,
                        centerSpaceRadius: 36,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'total',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888780),
                          ),
                        ),
                        Text(
                          '${(total / 1000).toStringAsFixed(0)}k',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: List.generate(categoryTotals.length, (i) {
                    final entry = categoryTotals[i];
                    final pct = total > 0
                        ? ((entry.value / total) * 100).toStringAsFixed(0)
                        : '0';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colors[i % colors.length],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$pct%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888780),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatAmount(entry.value),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarsCard extends StatelessWidget {
  const _BarsCard({
    required this.categoryTotals,
    required this.total,
    required this.colors,
  });
  final List<MapEntry<String, double>> categoryTotals;
  final double total;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final double maxVal = categoryTotals.isEmpty
        ? 1
        : categoryTotals.first.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détail par catégorie',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF888780),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(categoryTotals.length, (i) {
            final entry = categoryTotals[i];
            final ratio = maxVal > 0 ? entry.value / maxVal : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888780),
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF1EFE8),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors[i % colors.length],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 72,
                    child: Text(
                      '${_formatAmount(entry.value)} F',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LineChartCard extends StatelessWidget {
  const _LineChartCard({required this.monthlyData, required this.monthLabels});
  final List<double> monthlyData;
  final List<String> monthLabels;

  @override
  Widget build(BuildContext context) {
    final double maxRecorded = monthlyData.reduce((a, b) => a > b ? a : b);
    final double minVal = 0;
    final double maxVal = maxRecorded == 0 ? 100000 : maxRecorded * 1.15;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Évolution mensuelle',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF888780),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                minY: minVal,
                maxY: maxVal,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal > minVal ? (maxVal - minVal) / 3 : 1,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: const Color(0xFFF1EFE8), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= monthLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          monthLabels[idx],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888780),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      monthlyData.length,
                      (i) => FlSpot(i.toDouble(), monthlyData[i]),
                    ),
                    isCurved: true,
                    color: const Color(0xFF3266AD),
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, pct, bar, idx) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: const Color(0xFF3266AD),
                            strokeWidth: 0,
                            strokeColor: Colors.transparent,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF3266AD).withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatAmount(double amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(1)}M';
  } else if (amount >= 1000) {
    final formatted = amount.toInt().toString();
    final result = StringBuffer();
    for (int i = 0; i < formatted.length; i++) {
      if (i > 0 && (formatted.length - i) % 3 == 0) result.write(' ');
      result.write(formatted[i]);
    }
    return result.toString();
  }
  return amount.toInt().toString();
}