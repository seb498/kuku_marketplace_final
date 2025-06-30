import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class FarmerChatsScreen extends StatefulWidget {
  const FarmerChatsScreen({super.key});

  @override
  _FarmerChatsScreenState createState() => _FarmerChatsScreenState();
}

class _FarmerChatsScreenState extends State<FarmerChatsScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<Map<String, dynamic>>> _getConversations(String farmerId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId', isEqualTo: farmerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          final Map<String, Map<String, dynamic>> latestMessages = {};
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final customerId = data['customerId'] ?? '';
            final message = data['text'] ?? '';
            final timestamp = data['timestamp'];

            if (customerId.isNotEmpty &&
                message.isNotEmpty &&
                timestamp != null &&
                !latestMessages.containsKey(customerId)) {
              latestMessages[customerId] = {
                'lastMessage': message,
                'timestamp': timestamp,
                'customerId': customerId,
              };
            }
          }
          return latestMessages.values.toList();
        });
  }

  Future<String> _getCustomerName(String customerId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .get();
      return doc.exists && doc.data()!.containsKey('name')
          ? doc['name'] ?? 'Unknown User'
          : 'Unknown User';
    } catch (_) {
      return 'Unknown User';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    final farmerId = currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Inquiries'),
        backgroundColor: Colors.green.shade700,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getConversations(farmerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No messages yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final conversations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final convo = conversations[index];
              final lastMessage = convo['lastMessage'] ?? '';
              final timestamp = convo['timestamp'];
              final customerId = convo['customerId'] ?? '';

              return FutureBuilder<String>(
                future: _getCustomerName(customerId),
                builder: (context, nameSnapshot) {
                  final customerName = nameSnapshot.data ?? 'Loading...';

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF4CAF50),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: timestamp is Timestamp
                          ? Text(
                              timestamp.toDate().toLocal().toString().split(
                                '.',
                              )[0],
                              style: const TextStyle(fontSize: 10),
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              currentUserId: farmerId,
                              otherUserId: customerId,
                              otherUserName: customerName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
