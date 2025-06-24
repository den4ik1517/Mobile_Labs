class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('📦 My Deliveries'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              )
            ],
          ),
          body: Column(
            children: [
              _sensorPanel(state),
              // список доставок залишити без змін
            ],
          ),
        );
      },
    );
  }

  Widget _sensorPanel(HomeState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.teal.shade900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _sensorInfoTile('🌡️', '${state.temperature}°C', 'Температура'),
          _sensorInfoTile('💧', '${state.humidity}%', 'Вологість'),
          _sensorInfoTile('🌪️', '${state.pressure} hPa', 'Тиск'),
        ],
      ),
    );
  }

  Widget _sensorInfoTile(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    await SharedPrefs.setLoggedIn(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }
}
