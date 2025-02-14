import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<CarModel> cars = <CarModel>[].obs;
  final RxList<CarModel> filteredCars = <CarModel>[].obs;
  final RxBool isSearching = false.obs;
  final RxDouble searchBarHeight = 56.0.obs;

  @override
  void onInit() {
    super.onInit();
    cars.value = [
      CarModel(
        name: 'Rakel Jul',
        carModel: 'Porsche GT3',
        persons: '2',
        price: '\$250/day',
        image: 'assets/car4.png',
        driverImage: 'assets/dri1.png',
      ),
      CarModel(
        name: 'Sara Lord',
        carModel: 'Mercedes AMG',
        persons: '4',
        price: '\$180/day',
        image: 'assets/car2.png',
        driverImage: 'assets/dri2.png',
      ),
      CarModel(
        name: 'Muneir Naveed',
        carModel: 'Tesla Model S',
        persons: '4',
        price: '\$200/day',
        image: 'assets/car3.png',
        driverImage: 'assets/dri3.png',
      ),
    ];
    filteredCars.value = cars;
  }

  void searchCars(String query) {
    if (query.isEmpty) {
      filteredCars.value = cars;
      return;
    }
    
    filteredCars.value = cars.where((car) {
      return car.name.toLowerCase().contains(query.toLowerCase()) ||
          car.carModel.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (isSearching.value) {
      searchBarHeight.value = 80.0;
    } else {
      searchBarHeight.value = 56.0;
      filteredCars.value = cars;
    }
  }
}

class CarModel {
  final String name;
  final String carModel;
  final String persons;
  final String price;
  final String image;
  final String driverImage;

  CarModel({
    required this.name,
    required this.carModel,
    required this.persons,
    required this.price,
    required this.image,
    required this.driverImage,
  });
} 