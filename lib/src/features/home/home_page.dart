import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/login_page.dart';
import 'package:test1/src/features/home/delivery_model.dart';
import 'package:test1/src/features/home/mqtt_service.dart';
import 'package:test1/src/features/home/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isOfflineNotified = false;

  late MQTTClientWrapper _mqttClient;

  int temperature = 0;
  int humidity = 0;
  int pressure = 0;

  @override
  void initState() {
    super.initState();

    // MQTT init
    _mqttClient = MQTTClientWrapper(
      host: '0493295c8cb54e298c1d606ed7430d9e.s1.eu.hivemq.cloud',
      clientIdentifier: 'flutter_client_${DateTime.now()
          .millisecondsSinceEpoch}',
      username: 'denys',
      password: 'Qwerty123',
      onData: ({int? temperature, int? humidity, int? pressure}) {
        setState(() {
          if (temperature != null) this.temperature = temperature;
          if (humidity != null) this.humidity = humidity;
          if (pressure != null) this.pressure = pressure;
        });
      },
    );

    _mqttClient.prepareMqttClient();

    // Connectivity listener
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((result) {
      if (!mounted) return;
      if (result == ConnectivityResult.none && !_isOfflineNotified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have lost internet connection'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
        _isOfflineNotified = true;
        _mqttClient.disconnect();
      } else if (result != ConnectivityResult.none) {
        _isOfflineNotified = false;
        if (_mqttClient.connectionState !=
            MqttCurrentConnectionState.connected) {
          _mqttClient.prepareMqttClient();
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _mqttClient.disconnect();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SharedPrefs.setLoggedIn(false);
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveries = [
      DeliveryModel(title: 'Parcel to Kyiv',
          status: 'In Transit', date: '2025-05-18',),
      DeliveryModel(title: 'Docs to Lviv',
          status: 'Delivered', date: '2025-05-17',),
      DeliveryModel(title: 'Parts to Dnipro',
          status: 'Pending', date: '2025-05-20',),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 My Deliveries'),
        backgroundColor: Colors.teal.shade800,
        actions: [
          IconButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
            ),
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // MQTT Info Panel
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sensorInfoTile('🌡️', '$temperature°C', 'Температура'),
                _sensorInfoTile('💧', '$humidity%', 'Вологість'),
                _sensorInfoTile('🌪️', '$pressure hPa', 'Тиск'),
              ],
            ),
          ),

          // Delivery list
          Expanded(
            child: ListView.builder(
              itemCount: deliveries.length,
              itemBuilder: (context, index) {
                final item = deliveries[index];
                return Card(
                  margin: const EdgeInsets.symmetric
                    (horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon
                      (Icons.local_shipping, color: Colors.teal),
                    title: Text(item.title),
                    subtitle: Text('Status: ${item.status}'),
                    trailing: Text(item.date),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sensorInfoTile(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color:
        Colors.white, fontWeight: FontWeight.bold,),),
        Text(label, style: const TextStyle(color:
        Colors.white70, fontSize: 12,),),
      ],
    );
  }
}
