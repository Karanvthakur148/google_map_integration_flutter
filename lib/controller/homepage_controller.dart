import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class HomePageController extends GetxController {
  Rx<DateTime> openTime = DateTime.parse('1974-03-20 09:00:00.000').obs;
  Rx<DateTime> closeTime = DateTime.parse('1974-03-20 21:00:00.000').obs;
  RxMap<MarkerId, Marker> mapMarker = <MarkerId, Marker>{}.obs;
  RxString street = "".obs;
  RxString shopImage = "".obs;
  RxBool imageError = false.obs;

  Completer<GoogleMapController> mapController = Completer();

  RoundedLoadingButtonController submitButton =
      RoundedLoadingButtonController();

  Rx<AutovalidateMode> autoValidMode = AutovalidateMode.disabled.obs;
  RxBool locationLoading = false.obs;
  Rx<LatLng> currentLocation = const LatLng(0.0, 0.0).obs;
  Rx<LatLng> cameraPositon = const LatLng(0.0, 0.0).obs;

  RxInt selectTable = 2.obs;
  Future<void> locateMe() async {
    LocationData location = await Location().getLocation();
    currentLocation.value = LatLng(location.latitude!, location.longitude!);
    cameraPositon.value = LatLng(location.latitude!, location.longitude!);
    animateCameraPosition(cameraPositon.value);
    updateAddress();
    mapMarker[const MarkerId('current')] = Marker(
      markerId: const MarkerId('current'),
      position: currentLocation.value,
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController houseFlatFloor = TextEditingController();
  TextEditingController landmark = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void changeOpenTime(DateTime value) => openTime.value = value;

  void changeCloseTime(DateTime value) => closeTime.value = value;

  void changeSelectTable(int value) => selectTable.value = value;

  Future<void> updateAddress() async {
    var val = await geo.GeocodingPlatform.instance.placemarkFromCoordinates(
      cameraPositon.value.latitude,
      cameraPositon.value.longitude,
    );
    List<geo.Placemark> addres = await geo.placemarkFromCoordinates(
        cameraPositon.value.latitude, cameraPositon.value.longitude,
        localeIdentifier: "en");
    street.value = "";
    address.clear();
    geo.Placemark first = addres.first;
    geo.Placemark place = addres.last;
    street.value = first.name!;
    address.text =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${first.postalCode}, ${place.country}.';
  }

  Future<void> animateCameraPosition(LatLng position) async {
    GoogleMapController googleMapController = await mapController.future;
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 19.5,
      ),
    );
    googleMapController.animateCamera(cameraUpdate);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    LocationData location = await Location().getLocation();
    currentLocation.value = LatLng(location.latitude!, location.longitude!);
    cameraPositon.value = LatLng(location.latitude!, location.longitude!);
    updateAddress();
    mapMarker[const MarkerId('current')] = Marker(
      markerId: const MarkerId('current'),
      position: currentLocation.value,
    );
    update();
  }

  // Future<void> onSubmit() async {
  //   if (formKey.currentState!.validate()) {
  //     if (shopImage.value != "") {
  //       autoValidMode.value = AutovalidateMode.disabled;
  //       imageError.value = false;
  //       AuthDb authDb = AuthDb();
  //       String ownerId = authDb.getUserId()!;
  //       ShopWebService shopWebService = ShopWebService();
  //       Map<String, dynamic>? response = await shopWebService.registerShop(
  //         ownerId: ownerId,
  //         shopName: name.text,
  //         noOfBarber: selectTable.value.toString(),
  //         openTime: openTime.value.toString(),
  //         closeTime: openTime.toString(),
  //         shopImage: AppConverter().imageToBase64(
  //           File.fromUri(
  //             Uri.parse(shopImage.value),
  //           ),
  //         ),
  //         address: address.text,
  //       );
  //       AppToast.showDefaultToast(message: "Shop register successfully");
  //       Get.toNamed(AddShopCategoryScreen.routeName);
  //       await AppButton().successReset(submitButton);
  //     } else {
  //       imageError.value = true;
  //       await AppButton().errorReset(submitButton);
  //     }
  //   } else {
  //     autoValidMode.value = AutovalidateMode.always;
  //     if (shopImage.value == "") {
  //       imageError.value = true;
  //     } else {
  //       imageError.value = false;
  //     }
  //     await AppButton().errorReset(submitButton);
  //   }
  // }

  // Future<void> addServiceImage() async {
  //   XFile? image = await ImagePickerService.pickFromGallery();
  //   if (image != null) {
  //     CroppedFile? croppedImage =
  //         await ImagePickerService.rectangleCrop(imagePath: image.path);
  //     if (croppedImage != null) {
  //       File imageFile = File.fromUri(Uri.parse(croppedImage.path));
  //       shopImage.value = imageFile.path;
  //       imageError.value = false;
  //     }
  //   }
  // }
}
