import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:efc_nc/_app/app.locator.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore_for_file: deprecated_member_use
// import 'package:image_picker/image_picker.dart';
// import 'package:optiwins/core/_app/app.locator.dart';
// import 'package:optiwins/constants.dart';
// import 'package:optiwins/core/hive/hiveConfig.dart';
// import 'package:optiwins/core/hive/models/appLevelModel.dart';
// import 'package:optiwins/enums/app_enums.dart';
// import 'package:optiwins/uiHelpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
// import 'package:shimmer/shimmer.dart' as shimer;

enum ImagePickSource { camera, gallery }
enum BottomSheetType { FloatingBox }
enum SnackBarType { RedAndWhite, BlackAndYellow }

class UtilsService {
  final SnackbarService _snackBar = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  // AppLevelModel appLevelModel =
  //     HiveConfig.getSingleObject<AppLevelModel>(HiveBox.AppLevelModel);
  UtilsService() {
    setupSnackbarUi();
    _setupBottomSheetUi();
  }

  showErrorSnackBar({title, required msg}) {
    _snackBar.showCustomSnackBar(
      variant: SnackBarType.RedAndWhite,
      message: msg.toString(),
      title: title,

      duration: const Duration(seconds: 5),
      onTap: (_) {
        print('snackbar tapped');
      },
    );
  }

  showBottomSheet({child}) {
    _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.FloatingBox,
        data: {'child': child});
  }

  void _setupBottomSheetUi() {
    final builders = {
      BottomSheetType.FloatingBox: (context, sheetRequest, completer) =>
          _FloatingBoxBottomSheet(request: sheetRequest, completer: completer)
    };

    _bottomSheetService.setCustomSheetBuilders(builders);
  }

  getRandomNumber(int numberOfDigits) {
    var random = Random();
    double _rand = random.nextDouble();
    if (_rand < 0.1) {
      return getRandomNumber(numberOfDigits);
    } else {
      return (_rand * pow(10, numberOfDigits)).toInt();
    }
  }

  showInfoSnackBar(text) {
    _snackBar.showCustomSnackBar(
        variant: SnackBarType.RedAndWhite, message: text);
  }

  showLoadingDialog() {
    try {
      return _dialogService..showDialog(description: "Loading...");
    } catch (e, s) {
      print("$e , $s");
      _snackBar.showSnackbar(message: "Please wait....");
    }
  }

  closeLoadingDialog() {
    _dialogService.completeDialog(DialogResponse());
  }

  showSnackBar({title, required msg}) {
    _snackBar.showSnackbar(

      message: msg,
    );
  }


  showNotification(String text) {
    BotToast.showSimpleNotification(title: text.toString());
  }

  bool validateEmail(email) {
    if (email != null && email.length > 0) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      return regex.hasMatch(email);
    } else {
      return false;
    }
  }

  showToast(text, {background = Colors.red, textColor = Colors.white}) {
    // BotToast.showText(text: text ?? "Toast Message missing");
  }
  //
  // Future<DialogResponse?> showDeleteDialog(
  //     {String title = "", String description = ""}) {
  //   return _dialogService.showCustomDialog(
  //       variant: DialogType.DELETE,
  //       mainButtonTitle: "Delete",
  //       secondaryButtonTitle: "Cancel",
  //       title: title,
  //       description: description);
  // }
  //
  // Future<DialogResponse?> showFeedBackDialog(
  //     {String title = "", String description = ""}) {
  //   return _dialogService.showCustomDialog(
  //       variant: DialogType.FEEDBACK,
  //       mainButtonTitle: "Submit",
  //       secondaryButtonTitle: "Cancel",
  //       title: title,
  //       description: description);
  // }
  //
  // Future<DialogResponse?> showDialog(
  //     {title, description, image = "assets/img/stock_loader.gif"}) {
  //   return _dialogService.showCustomDialog(
  //       variant: DialogType.M2,
  //       hasImage: image != "",
  //       imageUrl: image,
  //       mainButtonTitle: "OK",
  //       secondaryButtonTitle: "Cancel",
  //       title: title,
  //       description: description);
  // }

  void setupSnackbarUi() {
    _snackBar.registerCustomSnackbarConfig(
      variant: SnackBarType.BlackAndYellow,
      config: SnackbarConfig(
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        borderRadius: 8,
        //dismissDirection: SnackDismissDirection.HORIZONTAL,
      ),
    );

    _snackBar.registerCustomSnackbarConfig(
      variant: SnackBarType.RedAndWhite,
      config: SnackbarConfig(
        backgroundColor: const Color(0xFF2F192D),
        textColor: const Color(0xFFFF2C5E),
        titleColor: const Color(0xFFFF2C5E),
        messageColor: const Color(0xFFFF2C5E),
        borderRadius: 1,
      ),
    );
  }

  // getFileUploadURL(
  //     {required String directoryName,
  //     ImageSource imageSource = ImageSource.camera}) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: imageSource,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     File imageFile = File(pickedFile.path);
  //
  //     String imagePath = imageFile.path;
  //     print("Image path in utils --------> $imagePath");
  //
  //     if (imageFile.path.isNotEmpty == true) {
  //       print("Entered if");
  //       showDialog(image: "assets/img/stock_loader.gif");
  //       // var headers = {
  //       //   'Authorization': '${AppConstants.FILE_UPLOAD_BEARER_TOKEN}'
  //       // };
  //       var request = http.MultipartRequest(
  //           'POST', Uri.parse(AppConstants.API_FILE_UPLOAD));
  //       request.fields
  //           .addAll({'directory': '$directoryName', 'fileType ': 'IMAGE'});
  //
  //       String testrandom = DateTime.now().toIso8601String();
  //
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'file', '${imageFile.path}',
  //           filename: testrandom));
  //
  //       http.StreamedResponse response = await request.send();
  //
  //       if (response.statusCode == 201) {
  //         var fileUploadResponse = await response.stream.bytesToString();
  //
  //         dynamic resp = json.decode(fileUploadResponse);
  //         closeLoadingDialog();
  //         return resp['url'];
  //       } else {
  //         closeLoadingDialog();
  //         showSnackBar(
  //           msg: "${response.reasonPhrase}",
  //         );
  //         print(response.reasonPhrase);
  //       }
  //     } else {
  //       print("path booll -------> ${imageFile.path.isNotEmpty}");
  //     }
  //   }
  // }
  //
  // getFileUploadURLForPDF({required String directoryName}) async {
  //   // XFile? pickedFile = await ImagePicker().pickImage(
  //   //   source: ImageSource.camera,
  //   //   maxWidth: 1800,
  //   //   maxHeight: 1800,
  //   // );
  //
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'pdf',
  //     ],
  //   );
  //
  //   if (result != null) {
  //     File imageFile = File(result.files.single.path!);
  //
  //     String imagePath = imageFile.path;
  //     print("Image path in utils --------> $imagePath");
  //
  //     if (imageFile.path.isNotEmpty == true) {
  //       print("Entered if in pdf url generator");
  //       showDialog(image: "assets/img/stock_loader.gif");
  //       // var headers = {
  //       //   'Authorization': '${AppConstants.FILE_UPLOAD_BEARER_TOKEN}'
  //       // };
  //       // var request = http.MultipartRequest(
  //       //     'POST', Uri.parse(AppConstants.API_FILE_UPLOAD));
  //       // request.fields
  //       //     .addAll({'isPublic': 'true', 'directory': 'csv', 'type': 'FILE'});
  //       // request.files.add(
  //       //     await http.MultipartFile.fromPath('files', '${imageFile.path}'));
  //       // request.headers.addAll(headers);
  //       var request = http.MultipartRequest(
  //           'POST', Uri.parse(AppConstants.API_FILE_UPLOAD));
  //       request.fields
  //           .addAll({'directory': '$directoryName', 'fileType ': 'FILE'});
  //
  //       String testrandom = DateTime.now().toIso8601String();
  //
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'file', '${imageFile.path}',
  //           filename: testrandom));
  //       http.StreamedResponse response = await request.send();
  //
  //       print("STREAM RESP DATA ABOVE --------> ${response.reasonPhrase}}");
  //       print(
  //           "STREAM RESP DATA ABOVE statusCode --------> ${response.statusCode}}");
  //
  //       if (response.statusCode == 201) {
  //         var fileUploadResponse = await response.stream.bytesToString();
  //
  //         dynamic resp = json.decode(fileUploadResponse);
  //
  //         print("STREAM RESP DATA --------> $resp");
  //
  //         closeLoadingDialog();
  //
  //         return resp['url'];
  //       } else {
  //         closeLoadingDialog();
  //
  //         showSnackBar(msg: "${response.reasonPhrase}");
  //
  //         print(response.reasonPhrase);
  //       }
  //     } else {
  //       print("path booll -------> ${imageFile.path.isNotEmpty}");
  //     }
  //   }
  // }

  // Shimmers

}

class UtilsTextField extends StatelessWidget {
  final String? title;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType textInputType;
  final bool? isRequired;
  const UtilsTextField(
      {Key? key,
      this.title,
      this.onChange,
      this.textInputType = TextInputType.text,
      this.initialValue,
      this.isRequired = true,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            onChanged: onChange!,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            keyboardType: textInputType,
            validator: isRequired!
                ? (val) => val != null && val.replaceAll(" ", "") != ""
                    ? null
                    : "Field required"
                : (val) => null,
            decoration: InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: "$title",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "Poppins",
                )),
          ),
        ),
      ],
    );
  }
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;
  const _FloatingBoxBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: request!.data['child'],
    );
  }
}
