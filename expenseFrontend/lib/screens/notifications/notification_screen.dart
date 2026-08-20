import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'Alerte Budget', 'desc': 'Vous avez atteint 80% de votre budget Alimentation.', 'date': 'Aujourd\'hui'},
      {'title': 'Rappel de Dépense', 'desc': 'N\'oubliez pas d\'ajouter vos reçus de carburant.', 'date': 'Hier'},
      {'title': 'Mise à jour Système', 'desc': 'Bienvenue sur la version optimisée de SenaTrack.', 'date': '12 Aug'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.notifications_active, color: Color(0xFF3B6334)),
            ),
            title: Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notif['desc']!),
            trailing: Text(notif['date']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          );
        },
      ),
    );
  }
}