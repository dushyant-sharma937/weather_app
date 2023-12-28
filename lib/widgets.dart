import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controller/home_controller.dart';

class CustomPopMenuButton extends StatelessWidget {
  const CustomPopMenuButton({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 40,
      onSelected: (value) async {
        switch (value) {
          case 1:
            homeController.openAppSettings();
            break;
          case 2:
            homeController.openLocationSettings();
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Open App Settings"),
        ),
        if (Platform.isAndroid || Platform.isWindows)
          const PopupMenuItem(
            value: 2,
            child: Text("Open Location Settings"),
          ),
      ],
    );
  }
}

class HalfCard extends StatelessWidget {
  const HalfCard({
    super.key,
    required this.homeController,
    required this.firstText,
    required this.secondText,
    required this.icon,
  });

  final HomeController homeController;
  final String firstText;
  final String secondText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.42,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstText,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  secondText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeelsLikeCard extends StatelessWidget {
  const FeelsLikeCard({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Feels like",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.thermometer),
                      const SizedBox(width: 10),
                      Text(
                        "${homeController.feelsLike.toString()}°C",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  homeController.weatherDesc.value,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }
}

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Today, ${DateFormat('MMM d').format(DateTime.now())}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('EEEE').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      homeController.weatherMain.value
                              .substring(0, 1)
                              .toUpperCase() +
                          homeController.weatherMain.value
                              .substring(1)
                              .toLowerCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Image.network(
                      homeController.weatherIconUrl.value,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.30,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homeController.temperature.toString(),
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "°C",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Text(
                        "${homeController.tempMin.toString()}°/${homeController.tempMax.toString()}°",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await homeController.fetchData();
                    },
                    icon: const Icon(CupertinoIcons.refresh_circled),
                    iconSize: 44,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
