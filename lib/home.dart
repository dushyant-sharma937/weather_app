import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await reset();
    });
  }

  Future<void> reset() async {
    var temp = await homeController.getCurrentPosition();
    if (!temp) {
      homeController.isLoading.value = false;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to get your current location."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    var value = await homeController.fetchData();
    setState(() {});
    if (value) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Weather Forecast fetched successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Weather forecase not available at this time."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Weather Forecast App"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Obx(
        () => homeController.isLoading.value
            ? Center(
                child: Lottie.asset(
                'assets/animation/loading_animation_2.json',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.3,
              ))
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
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Weather Forecast fetched successfully"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    if (!context.mounted) return;
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
                                  "${homeController.name.value}, ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${homeController.country.value}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                // IconButton(
                                //   onPressed: () async {},
                                //   icon: const Icon(CupertinoIcons.search),
                                // ),
                                MyButton(
                                  homeController: homeController,
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HalfCard(
                                  homeController: homeController,
                                  firstText: "Air Pressure",
                                  secondText:
                                      "${homeController.pressure.toString()} atm",
                                  icon: Icons.atm_rounded,
                                ),
                                const Spacer(),
                                HalfCard(
                                  homeController: homeController,
                                  firstText: "Visibility",
                                  secondText:
                                      "${homeController.visibility.toString()} m",
                                  icon: CupertinoIcons.eye_fill,
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HalfCard(
                                  homeController: homeController,
                                  firstText: "Latitude",
                                  secondText:
                                      "${homeController.latitude.toString()}°",
                                  icon: CupertinoIcons.location_circle,
                                ),
                                const Spacer(),
                                HalfCard(
                                  homeController: homeController,
                                  firstText: "Longitude",
                                  secondText:
                                      "${homeController.longitude.toString()}°",
                                  icon: CupertinoIcons.location_circle,
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await reset();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
