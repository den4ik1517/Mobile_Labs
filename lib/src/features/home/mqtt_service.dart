import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnSensorData = void Function({
int? temperature,
int? humidity,
int? pressure,
});

enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  errorWhenConnecting,
}

enum MqttSubscriptionState { idle, subscribed }

class MQTTClientWrapper {
  final String host;
  final int port;
  final String clientIdentifier;
  final String? username;
  final String? password;
  final OnSensorData onData;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.idle;

  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
  _subscriptionListener;
  Timer? _reconnectTimer;

  // Топіки, на які підписуємося
  final List<String> topics = [
    'sensor/temperature',
    'sensor/humidity',
    'sensor/pressure',
  ];

  MQTTClientWrapper({
    required this.host,
    required this.onData,
    required String clientIdentifier,
    this.port = 8883,
    String? clientId,
    this.username,
    this.password,
  }) : clientIdentifier = clientId ??
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}';

  Future<void> prepareMqttClient() async {
    if (_client == null) {
      _setupMqttClient();
    }
    await _connectClient();

    if (connectionState == MqttCurrentConnectionState.connected) {
      _subscribeToTopics(topics);
      _listenToUpdates();
    } else {
      debugPrint('❌ Failed to connect to broker');
      _scheduleReconnect();
    }
  }

  void _setupMqttClient() {
    _client = MqttServerClient.withPort(host, clientIdentifier, port)
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..logging(on: true)  // Вмикаємо логування
      ..keepAlivePeriod = 60
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected
      ..onSubscribed = _onSubscribed
      ..setProtocolV311();

    // Обробка помилки з'єднання
    _client?.onUnsubscribed = (topic) {
      debugPrint('⚠️ Unsubscribed from $topic');
    };
  }

  Future<void> _connectClient() async {
    connectionState = MqttCurrentConnectionState.connecting;

    final connMsg = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    if (username != null && password != null) {
      connMsg.authenticateAs(username!, password!);
    }

    _client?.connectionMessage = connMsg;

    try {
      await _client?.connect();
    } on Exception catch (e) {
      debugPrint('Exception during connect: $e');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      _client?.disconnect();
      _scheduleReconnect();
      return;
    }

    final status = _client?.connectionStatus;
    if (status?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.connected;
      debugPrint('✅ Connected to broker');
    } else {
      debugPrint('Connection failed - status: ${status?.state},'
          ' return code: ${status?.returnCode}');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      _client?.disconnect();
      _scheduleReconnect();
    }
  }

  void _subscribeToTopics(List<String> topics) {
    if (connectionState != MqttCurrentConnectionState.connected) return;

    for (var topic in topics) {
      _client?.subscribe(topic, MqttQos.atMostOnce);
    }
  }

  void _listenToUpdates() {
    // Якщо вже слухаємо - не додаємо повторно
    if (_subscriptionListener != null) return;

    _subscriptionListener = _client?.updates?.listen((messages) {
      for (final msg in messages) {
        final payload = MqttPublishPayload.bytesToStringAsString(
          (msg.payload as MqttPublishMessage).payload.message,
        );
        debugPrint('🔔 [${msg.topic}] → $payload');

        final int? value = int.tryParse(payload);
        if (value == null) continue;

        switch (msg.topic) {
          case 'sensor/temperature':
            onData(temperature: value);
            break;
          case 'sensor/humidity':
            onData(humidity: value);
            break;
          case 'sensor/pressure':
            onData(pressure: value);
            break;
        }
      }
    });
  }

  void _onSubscribed(String topic) {
    subscriptionState = MqttSubscriptionState.subscribed;
    debugPrint('✅ Subscribed to $topic');
  }

  void _onDisconnected() {
    connectionState = MqttCurrentConnectionState.disconnected;
    debugPrint('❌ Disconnected from broker');

    // Зупиняємо слухачів, якщо вони є
    _subscriptionListener?.cancel();
    _subscriptionListener = null;

    // Запускаємо таймер перепідключення
    _scheduleReconnect();
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.connected;
    debugPrint('✅ Connected to broker');

    // Після підключення підписуємося та слухаємо оновлення
    _subscribeToTopics(topics);
    _listenToUpdates();
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null) return; // Уже перепідключаємось

    debugPrint('⏳ Scheduling reconnect in 5 seconds...');
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      _reconnectTimer = null;
      debugPrint('♻️ Attempting to reconnect...');
      await prepareMqttClient();
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _subscriptionListener?.cancel();
    _subscriptionListener = null;

    _client?.disconnect();
    connectionState = MqttCurrentConnectionState.disconnected;
  }
}
