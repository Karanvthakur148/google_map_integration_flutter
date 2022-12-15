import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'controller/homepage_controller.dart';

class HomePage extends GetView<HomePageController> {
  static const String routeName = "/homePage";
  //CameraPosition intialCameraPosition;
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: Stack(
                children: [
                  SafeArea(
                    child: Obx(
                      () => GoogleMap(
                        mapType: MapType.normal,
                        onMapCreated: (googleMapController) {
                          controller.mapController
                              .complete(googleMapController);
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                          controller.cameraPositon.value.latitude,
                          controller.cameraPositon.value.longitude,
                        )),
                        markers: controller.mapMarker.values.toSet(),
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                        buildingsEnabled: true,
                        onCameraIdle: () async {
                          controller.locationLoading.value = true;
                          await controller.updateAddress();
                          controller.locationLoading.value = false;
                        },
                        onCameraMove: (value) {
                          controller.cameraPositon.value = LatLng(
                              value.target.latitude, value.target.longitude);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/location.svg",
                        //AppImages.location,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    left: 120.w,
                    right: 120.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.my_location_outlined,
                            color: Colors.orange.shade800,
                          ),
                          Text(
                            "LOCATE ME",
                            style: TextStyle(
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        controller.locateMe();
                      },
                    ),
                  ),
                  Positioned(
                    top: 20.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade600,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Obx(
                () => Visibility(
                  visible: !controller.locationLoading.value,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SELECT SHOP LOCATION",
                          style: TextStyle(
                            fontSize: 11.sp,
                            letterSpacing: 1,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                SizedBox(width: 10.w),
                                Text(
                                  controller.street.value,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  backgroundColor: Colors.grey.shade50,
                                ),
                                onPressed: () {
                                  Get.to(() => SearchLocation());
                                },
                                child: Text(
                                  "CHANGE",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    letterSpacing: 1,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Text(
                                controller.address.text,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  letterSpacing: 0.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            // const Spacer(flex: 3)
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade800,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("CONFIRM LOCATION"),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchLocation extends PlacesAutocompleteWidget {
  SearchLocation({Key? key})
      : super(
          key: key,
          apiKey: dotenv.env['GOOGLEKEY']!,
          sessionToken: Uuid().generateV4(),
          language: "en",
          region: "mp",
          components: [
            Component(Component.country, "in"),
          ],
          offset: 0,
          radius: 1000,
          types: [],
          strictbounds: false,
          mode: Mode.overlay,
        );

  @override
  SearchLocationState createState() => SearchLocationState();
}

class SearchLocationState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  "Select location to add address",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: SizedBox(
                height: 50,
                child: AppBarPlacesAutoCompleteTextField(
                  textDecoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.sp),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade700,
                    ),
                    hintText: "Try Vijay Nagar, LIG etc ...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PlacesAutocompleteResult(
                onTap: (p) async {
                  Get.back();
                  await displayPrediction(
                      p, context, Get.find<HomePageController>());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> displayPrediction(
    Prediction? p, BuildContext context, HomePageController controller) async {
  if (p != null) {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: dotenv.get('GOOGLEKEY'),
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    LatLng position = LatLng(
      detail.result.geometry!.location.lat,
      detail.result.geometry!.location.lng,
    );
    controller.cameraPositon.value = position;
    await controller.animateCameraPosition(position);
    await controller.updateAddress();
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
