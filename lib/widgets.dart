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
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.inverseSurface,
              spreadRadius: 2,
              offset: (Theme.of(context).brightness == Brightness.dark)
                  ? const Offset(0, 2)
                  : const Offset(0, -2),
              blurRadius: 20.0,
              blurStyle: BlurStyle.outer,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstText,
              style: const TextStyle(
                fontSize: 18,
              ),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    secondText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.inverseSurface,
                spreadRadius: 2,
                offset: (Theme.of(context).brightness == Brightness.dark)
                    ? const Offset(0, 2)
                    : const Offset(0, -2),
                blurRadius: 20.0,
                blurStyle: BlurStyle.outer,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                Theme.of(context)
                    .colorScheme
                    .tertiaryContainer
                    .withOpacity(0.4),
              ],
            ),
          ),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                  maxLines: 2,
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

  Future<void> reset(BuildContext context) async {
    var value = await homeController.fetchData();
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
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.inverseSurface,
              spreadRadius: 2,
              offset: (Theme.of(context).brightness == Brightness.dark)
                  ? const Offset(0, 2)
                  : const Offset(0, -2),
              blurRadius: 20.0,
              blurStyle: BlurStyle.outer,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.6),
            ],
          ),
        ),
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Theme.of(context).colorScheme.secondary,
              //     width: 2,
              //   ),
              // ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homeController.temperature.toString(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "°C",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Text(
                        "${homeController.tempMin.toString()}°/${homeController.tempMax.toString()}°",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await reset(context);
                    },
                    icon: const Icon(CupertinoIcons.refresh_circled),
                    iconSize: 40,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                ],
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.homeController});

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.search),
      onPressed: () {
        // Show the dialog when the button is pressed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
              homeController: homeController,
            );
          },
        );
      },
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({super.key, required this.homeController});
  final HomeController homeController;

  @override
  MyDialogState createState() => MyDialogState();
}

class MyDialogState extends State<MyDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Define the range of values for the animation
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // Start the popping animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: AlertDialog(
            title: const Text('Enter Coordinates'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Value of latitude cannot be empty';
                    }
                    if (value.contains(",") || value.contains("-")) {
                      return 'Please enter a valid latitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Value of latitude cannot be empty';
                    }
                    if (!value.contains(",") || !value.contains("-")) {
                      return 'Please enter a valid latitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (_latitudeController.text.isEmpty ||
                            _longitudeController.text.isEmpty) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Some of the field is/are empty."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        if (_latitudeController.text.contains(",")) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Latitude is invalid."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        if (_longitudeController.text.contains(",")) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Longitude is invalid."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        // Save the values and close the dialog
                        widget.homeController.latitude.value =
                            _latitudeController.text.trim().toString();
                        widget.homeController.longitude.value =
                            _longitudeController.text.trim().toString();
                        var value = await widget.homeController.fetchData();
                        if (value) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Weather Forecast fetched successfully"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Weather forecase not available at this time."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose the animation controller to avoid memory leaks
    _controller.dispose();
    super.dispose();
  }
}
