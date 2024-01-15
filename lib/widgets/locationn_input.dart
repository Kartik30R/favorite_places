import 'dart:convert';
import 'dart:ui';
import 'package:favorite_places/models/places.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedlocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedlocation == null) {
      return '';
    }
    final lng = _pickedlocation!.longitude;
    final lat = _pickedlocation!.latitude;
    return 'https://api.maptiler.com/maps/streets/static/$lat,$lng,16/600x300.png?key=FLlifCg1hJ4volLUhlo7';
  }

  void _getcurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    final url = Uri.parse(
        'https://api.maptiler.com/geocoding/$lng,$lat.json?key=FLlifCg1hJ4volLUhlo7');
    if (lat == null || lng == null) {
      return;
    }
    final response = await http.get(url);
    final resData = json.decode(response.body);
    print(resData.toString());
    final address = resData['result'][0]['formatted_address'];

    setState(() {
      _pickedlocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isGettingLocation = false;
    });

    print(locationData.latitude);
    print(locationData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text('no location',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground));
    if (_pickedlocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.2))),
            height: 170,
            width: double.infinity,
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getcurrentLocation,
              label: Text('Get Current Location'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text('Select on map'),
              icon: Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
