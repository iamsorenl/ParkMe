import 'package:flutter/material.dart';
import 'package:parkme/app/persisten_nav_padding.dart';
import 'package:parkme/components/address_autocomplete/components/address_functions.dart';
// import './widgets/Picker.dart';
import './form_views/address.dart';
import './form_views/schedule.dart';
import './form_views/metadata.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/request_handlers/spot_request.dart';
import 'package:image_picker/image_picker.dart';

class CreateSpotPage extends StatefulWidget {
  final VoidCallback onSpotCreationSuccess;
  const CreateSpotPage({Key? key, required this.onSpotCreationSuccess})
      : super(key: key);

  @override
  State<CreateSpotPage> createState() => _CreateSpotPageState();
}

class _CreateSpotPageState extends State<CreateSpotPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime date = DateTime.now();
  String errorText = "";
  double currentPage = 0.0;
  List<XFile>? imageList;

  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    addressController.clear();
    zipcodeController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    priceController.clear();
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();
    date = DateTime.now();
    imageList = null;
    controller.jumpToPage(0); // Navigate back to the first form page.
  }

  MaterialBanner errorBanner(String text) {
    return MaterialBanner(
      padding: const EdgeInsets.all(20),
      content: Text(text),
      leading: const Icon(Icons.error),
      backgroundColor: Colors.red,
      actions: <Widget>[
        TextButton(
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          onPressed: () =>
              {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  Future<void> handleChange(value, placeId) async {
    try {
      final res = await getPlaceDetails(placeId);
      dynamic fields = parseAddressComponent(res['address_components']);
      addressController.text = fields["addr"];
      zipcodeController.text = fields["zipcode"];
      cityController.text = fields["locality"];
      stateController.text = fields["region"];
      countryController.text = fields["country"];
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
        ..removeCurrentMaterialBanner()
        ..showMaterialBanner(errorBanner("Error Fetching Address Info"));
    }
    setState(() {
      errorText = "";
    });
  }

  void changeDate(DateTime newDate) {
    return setState(() {
      date = newDate;
    });
  }

  void selectImages(List<XFile> files) {
    return setState(() {
      imageList = files;
    });
  }

  void selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (newTime != null) {
      setState(() {
        startTime = newTime;
      });
    }
  }

  void selectEndTime() async {
    final TimeOfDay? newEndTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (newEndTime != null) {
      setState(() {
        endTime = newEndTime;
      });
    }
  }

  Future<void> postSpot() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      String address =
          "${addressController.text}, ${cityController.text}, ${zipcodeController.text}, ${stateController.text}, ${countryController.text}";

      double lat = await getLat(address, 0);
      double long = await getLng(address, 0);
      Object data = {
        "time": {
          "end": DateTime(
                  date.year, date.month, date.day, endTime.hour, endTime.minute)
              .toUtc()
              .toIso8601String(),
          "start": DateTime(date.year, date.month, date.day, startTime.hour,
                  startTime.minute)
              .toUtc()
              .toIso8601String(),
        },
        "address": {
          "addr": addressController.text,
          "zipcode": zipcodeController.text,
          "locality": cityController.text,
          "region": stateController.text,
          "country": countryController.text,
        },
        "coords": {
          "lat": lat,
          "long": long,
        },
        "description": descriptionController.text,
        "priceRate": int.parse(priceController.text),
        "date": date.toIso8601String(),
        "name": nameController.text,
      };
      final response =
          await SpotRequest().createSpot(token, data, imageList ?? []);
      //print(response);
      if (response.statusCode == 201) {
        widget.onSpotCreationSuccess();
        resetForm();
        //final Map data = jsonDecode(response.body);
        // HANDLE Parking Spot
        //final prefs = await SharedPreferences.getInstance();
        //await prefs.setString('name', data['name']);
        // await prefs.setString('token', data['token']);
        //if (!mounted) return;
        // ignore: use_build_context_synchronously
        /*
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TheHomePage()),
          (route) => route.settings.name == '/',
        );
        */
      } else {
        throw Exception("Error processing request");
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
        ..removeCurrentMaterialBanner()
        ..showMaterialBanner(errorBanner("Error processing request"));
    }
  }

  final controller = PageController();
  // static const duration = Duration(milliseconds: 300);
  // static const curve = Curves.ease;

  _onPageViewChange(int page) {
    setState(() {
      currentPage = page.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      AddressForm(
          address: addressController,
          zip: zipcodeController,
          city: cityController,
          state: stateController,
          country: countryController,
          handleChange: handleChange),
      ScheduleForm(
        start: startTime,
        end: endTime,
        date: date,
        handleChange: () => {},
        handleDateChange: changeDate,
        selectStartTime: selectStartTime,
        selectEndTime: selectEndTime,
      ),
      MetadataForm(
        price: priceController,
        desc: descriptionController,
        name: nameController,
        handleChange: () => {},
        handleSubmit: postSpot,
        imageSelect: selectImages,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('ParkMe'),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: _onPageViewChange,
        children: pages,
      ),
      persistentFooterButtons: <Widget>[
        Center(
          child: DotsIndicator(
            dotsCount: pages.length,
            position: currentPage,
          ),
        ),
        const PersistentNavPadding()
      ],
      bottomNavigationBar: const BottomAppBar(),
    );
  }
}
