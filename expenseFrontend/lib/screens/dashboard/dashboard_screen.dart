import 'package:expenses/screens/settings_screen.dart';
import 'package:expenses/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/date_utils.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../budget/budget_screen.dart';
import '../expenses/expense_list_screen.dart';
import '../categories/category_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _dashboardFuture = ApiService.fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('SenaTrack', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: const Padding(
              padding: EdgeInsets.only(right: 16, left: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF3B6334),
                child: Text('E', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final double totalBudget = (data['total_budget'] as num).toDouble();
            final double totalExpenses = (data['total_expenses'] as num).toDouble();
            final double remaining = totalBudget - totalExpenses;
            final List recentExpenses = data['recent_expenses'] ?? [];

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte du Solde Global
                  _buildBalanceCard(totalBudget, totalExpenses, remaining),
                  const SizedBox(height: 20),

                  // Actions Rapides
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionButton(Icons.account_balance_wallet, 'Budgets', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetScreen()));
                      }),
                      _buildQuickActionButton(Icons.receipt_long, 'Dépenses', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseListScreen()));
                      }),
                      _buildQuickActionButton(Icons.category, 'Catégories', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryListScreen()));
                      }),
                      _buildQuickActionButton(Icons.bar_chart, 'Stats', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section Dernières Dépenses
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dépenses Récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseListScreen())),
                        child: const Text('Voir tout'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...recentExpenses.map((exp) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFFEBEE),
                            child: Icon(Icons.arrow_downward, color: Colors.redAccent),
                          ),
                          title: Text(exp['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${exp['category']} • ${AppDateUtils.formatDate(exp['date'])}'),
                          trailing: Text(
                            '-${exp['amount']} FCFA',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 14),
                          ),
                        ),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double total, double spent, double remaining) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B6334), Color(0xFF558B2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Solde Restant', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            '${remaining.toStringAsFixed(0)} FCFA',
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceDetail('Budget Total', '${total.toStringAsFixed(0)} FCFA'),
              _buildBalanceDetail('Dépenses', '${spent.toStringAsFixed(0)} FCFA'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(icon, color: const Color(0xFF3B6334)),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Victoire Estelle S. HOUNKPATIN'),
            accountEmail: Text('victoire@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('S', style: TextStyle(fontSize: 24, color: Color(0xFF3B6334))),
            ),
            decoration: BoxDecoration(color: Color(0xFF3B6334)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Tableau de Bord'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Statistiques'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}