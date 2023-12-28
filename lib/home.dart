import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:weather_app/controller/home_controller.dart';
import 'package:weather_app/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Obx(
        () => homeController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: homeController.weatherMain.value.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Please click on the button below to fetch weather data",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  var value = await homeController.fetchData();
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Weather Forecast fetched successfully"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Something went wrong"),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: const Text("Weather Forecast"),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${homeController.name.value}, ${homeController.country.value}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () async {},
                                  icon: const Icon(CupertinoIcons.search),
                                ),
                                CustomPopMenuButton(
                                    homeController: homeController),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            MainCard(homeController: homeController),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            FeelsLikeCard(homeController: homeController),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HalfCard(
                                  homeController: homeController,
                                  firstText: "Wind speed",
                                  secondText:
                                      "${homeController.windSpeed.toString()} km/h",
                                  icon: CupertinoIcons.wind,
                                ),
                                const Spacer(),
                                HalfCard(
                                  homeController: homeController,
                                  firstText: "Humidity",
                                  secondText:
                                      "${homeController.humidity.toString()}%",
                                  icon: CupertinoIcons.drop,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: MaterialButton(
                                onPressed: () async {
                                  var value = await homeController.fetchData();
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Weather Forecast fetched successfully"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Something went wrong"),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: const Text("Weather Forecast"),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await homeController.getCurrentPosition();
          setState(() {});
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
