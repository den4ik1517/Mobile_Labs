part of 'home_cubit.dart';

abstract class HomeState {
  final int temperature;
  final int humidity;
  final int pressure;

  const HomeState({
    this.temperature = 0,
    this.humidity = 0,
    this.pressure = 0,
  });
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSensorData extends HomeState {
  const HomeSensorData({
    int temperature = 0,
    int humidity = 0,
    int pressure = 0,
  }) : super(
    temperature: temperature,
    humidity: humidity,
    pressure: pressure,
  );
}

class HomeOffline extends HomeState {
  const HomeOffline({
    int temperature = 0,
    int humidity = 0,
    int pressure = 0,
  }) : super(
    temperature: temperature,
    humidity: humidity,
    pressure: pressure,
  );
}

class HomeReconnected extends HomeState {
  const HomeReconnected({
    int temperature = 0,
    int humidity = 0,
    int pressure = 0,
  }) : super(
    temperature: temperature,
    humidity: humidity,
    pressure: pressure,
  );
}
