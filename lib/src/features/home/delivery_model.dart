class DeliveryModel {
  final String title;
  final String status;
  final String date;

  DeliveryModel({required this.title,
    required this.status, required this.date,});

  static List<DeliveryModel> sampleDeliveries = [
    DeliveryModel(title: 'Parcel to Kyiv',
        status: 'In Transit', date: '2025-05-18',),
    DeliveryModel(title: 'Docs to Lviv',
        status: 'Delivered', date: '2025-05-17',),
    DeliveryModel(title: 'Parts to Dnipro',
        status: 'Pending', date: '2025-05-20',),
  ];
}
