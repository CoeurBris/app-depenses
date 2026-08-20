import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Utilisateur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF3B6334),
                child: Text('E', style: TextStyle(fontSize: 36, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Utilisateur SenaTrack', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('user@senatrack.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Informations personnelles'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Sécurité & Mot de passe'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}