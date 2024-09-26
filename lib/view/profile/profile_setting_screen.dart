import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly/config/default_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/constant.dart';
import 'package:dio/dio.dart';
import 'dart:io' as File;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';

import '../../services/main_model.dart';

class ProfileSettingScreen extends StatefulWidget {
  final MainModel model;

  ProfileSettingScreen(this.model);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _rolesController = TextEditingController();
  var _phoneController = TextEditingController();
  var _cityController = TextEditingController();
  var _addressController = TextEditingController();
  var _zipController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late XFile _imageFile;
  dynamic _pickImageError;

  Timer? _timer;
  var _isSubmitted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //
    initProfile();
  }

  void initProfile() {
    _nameController.text = widget.model.nama;
    _emailController.text = widget.model.email;
    _rolesController.text = widget.model.role;
    _phoneController.text = widget.model.phone;
    _addressController.text = widget.model.address;
    _cityController.text = widget.model.city;
    _zipController.text = widget.model.zipCode;
  }

  Future _validateAndSubmit(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'zip_code': _zipController.text,
        'city': _cityController.text,
      };

      var responseData = await model.editProfile(data);
      if (responseData["data"] != null) {
        print("Response edit profile: $responseData");
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
        //
        setState(() => _isSubmitted = false);
        //
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _addressController.clear();
        _cityController.clear();
        _zipController.clear();

        Navigator.of(context).pop();

        await model.fetchUser();
      } else {
        print("Unathorized");
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              model.message,
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        setState(() => _isSubmitted = false);
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
      // });
    } catch (e) {
      //
      setState(() => _isSubmitted = false);
      _timer?.cancel();
      await EasyLoading.dismiss();
      print("Unathorized");
    }
  }
// Function to show the info dialog
  void _showInfoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Information sur l\'image du profil : '),
          content: Text('Il s\'agit de l\'image de votre profil utilisée sur votre page HelloHome pour être montrée aux visiteurs.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        backgroundColor: ConstColors.whiteFontColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: ConstColors.textColor,
              size: 20,
            ),
          ),
          title: Text(
            "Profile",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Container(
                  height: 120,
                  padding: EdgeInsets.all(2),
                  width: 120,
                  decoration: BoxDecoration(
                      color: ConstColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          height: 120,
                          width: 120,
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          imageUrl: model.user.image == null
                              ? ""
                              : "${Constant.baseUrl}${Constant.publicAssets}${model.user.image}",
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/Web and Technology/user.svg',
                              height: 100,
                              color: ConstColors.whiteFontColor,
                            ),
                          ),
                        ),
                      ),
                      // Info Icon positioned above the circular image
                      Positioned(
                        top: -4, // Adjust as needed to position vertically
                        right: 0, // Centered horizontally (adjust based on size)
                        child: GestureDetector(
                          onTap: () {
                            // Show explanation when the info icon is tapped
                            _showInfoDialog(context);
                          },
                          child: Icon(
                            Icons.info_outlined, // Info icon
                            color: Colors.black, // Change color as needed
                            size: 35, // Adjust size as needed
                          ),
                        ),
                      ),

                      // Camera Icon
                      Positioned(
                        right: 0.0,
                        bottom: 0.0,
                        child: GestureDetector (
                          onTap: () async {
                           _showPicker(context, model);
                          },
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            color: ConstColors.primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  )
                ,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          hintText: "Enter full name",
                          inputType: TextInputType.name,
                          obscureText: false,
                          image: DefaultImages.profile,
                          labelText: "Nom",
                        ),
                        SizedBox(height: 7),
                        _isSubmitted && _nameController.text.length < 3 ||
                                _isSubmitted && _nameController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _emailController.text.isEmpty
                                      ? "Name ne peut pas être vide."
                                      : "Name doit avoir au moins 3 caractères.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: 7),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Enter email address",
                          enabled: false,
                          inputType: TextInputType.emailAddress,
                          obscureText: false,
                          image: '',
                          labelText: "EMAIL",
                        ),
                        SizedBox(height: 7),
                        CustomTextField(
                          controller: _rolesController,
                          hintText: "Enter role",
                          enabled: false,
                          inputType: TextInputType.text,
                          obscureText: false,
                          image: '',
                          labelText: "ROLE",
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Tel :",
                            style: pRegular14.copyWith(
                              fontSize: 14,
                              color: ConstColors.text2Color,
                            ),
                          ),
                        ),
                        IntlPhoneField(keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          decoration: InputDecoration(
                            fillColor: const Color(0xffFBFBFB),
                            filled: true,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xffF3F2F2),
                              ),
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xffF3F2F2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: ConstColors.primaryColor,
                              ),
                            ),
                          ),
                          disableLengthCheck: true,
                          initialCountryCode: 'FR',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                        const SizedBox(height: 7),
                        _isSubmitted && _phoneController.text.length < 9 ||
                                _isSubmitted && _phoneController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _phoneController.text.isEmpty
                                      ? "Phone ne peut pas être vide."
                                      : "Phone Number doit avoir au moins 9 caractères.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 7),
                        CustomTextField(
                          controller: _addressController,
                          hintText: "Address",
                          inputType: TextInputType.text,
                          obscureText: false,
                          image: "",
                          labelText: "Adresse :",
                        ),
                        const SizedBox(height: 7),
                        _isSubmitted && _addressController.text.length < 9 ||
                                _isSubmitted && _addressController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _addressController.text.isEmpty
                                      ? "Address ne peut pas être vide."
                                      : "Address doit avoir au moins 9 caractères.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        CustomTextField(
                          controller: _cityController,
                          hintText: "veuillez entrer votre message personnel",
                          inputType: TextInputType.text,
                          obscureText: false,
                          image: "",
                          labelText: "Votre message :",
                        ),
                        const SizedBox(height: 7),
                        // _isSubmitted && _cityController.text.length < 5 ||
                        _isSubmitted && _cityController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  // _cityController.text.isEmpty
                                  //     ?
                                  "City ne peut pas être vide.",
                                  // : "City must have atleast 5 character.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        CustomTextField(
                          controller: _zipController,
                          hintText: "Zip Code",
                          inputType: TextInputType.number,
                          obscureText: false,
                          image: "",
                          labelText: "Code Postal :",
                        ),
                        _isSubmitted && _zipController.text.length < 5 ||
                                _isSubmitted && _zipController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _zipController.text.isEmpty
                                      ? "Zip Code ne peut pas être vide."
                                      : "Zip Code doit avoir au moins 5 caractères.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 14)
                      ],
                    ),
                  ],
                ),
              ),
              CusttomButton(
                color: ConstColors.primaryColor,
                text: "Enregisrer",
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();

                  setState(() => _isSubmitted = true);
                  if (_nameController.text.length > 2 &&
                      _nameController.text.isNotEmpty &&
                      _phoneController.text.isNotEmpty &&
                      _phoneController.text.length > 8 &&
                      _addressController.text.isNotEmpty &&
                      _addressController.text.length > 10 &&
                      _cityController.text.isNotEmpty &&
                      // _cityController.text.length > 4 &&
                      _zipController.text.isNotEmpty &&
                      _zipController.text.length > 4) {
                    await _validateAndSubmit(model);
                  } // Get.offAll(
                  //   const TabScreen(),
                  //   transition: Transition.rightToLeft,
                  // );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }
  void _showPermissionDeniedDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Permission Denied"),
          content: Text(
              "We need access to your photo library to upload your profile picture for use in your QR code."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Permission.photos.request(); // Request permission again
              },
              child: Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog when permission is permanently denied
  void _showPermanentDenialDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Permission Permanently Denied"),
          content: Text(
              "You have permanently denied access to the photo library. To enable it, go to your device settings and allow photo access."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Open device settings
              },
              child: Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showPicker(context, MainModel model) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Text('Change Profile Photo', style: pSemiBold20)),
                  SizedBox(height: 10),
                  ListTile(
                      leading: SvgPicture.asset(
                          'assets/icons/Media/gallery.svg',
                          height: 40,
                          color: ConstColors.primaryColor),
                      title:
                          new Text('Choose from gallery', style: pSemiBold18),
                      onTap: () async {
                        // _imgFromGallery();
                        Navigator.of(context).pop();
                        onImageButtonPressed(model, ImageSource.gallery);
                       //  print("Requesting permission...");
                       //
                       //  PermissionStatus status = await Permission.photos.request();
                       // // var status=await Permission.photos.status;
                       //  print("Permission status: $status");
                       //
                       //  if (status.isGranted) {
                       //    print("Permission granted");
                       //    await onImageButtonPressed(model, ImageSource.gallery);
                       //  } else if (status.isDenied) {
                       //    print("Permission denied");
                       //    _showPermissionDeniedDialog(context);
                       //  } else if (status.isPermanentlyDenied) {
                       //    print("Permission permanently denied");
                       //    _showPermanentDenialDialog(context);
                       // }

                      }),
                  SizedBox(height: 10),
                  // new ListTile(
                  //   // leading: SvgPicture.asset("assets/icons/camera.svg",
                  //   //     height: 60,
                  //   //     color: Pallete.subPrimary,
                  //   //     semanticsLabel: 'A red up arrow'),
                  //   title: new Text('Buka Kamera',
                  //       style: TextStyle(
                  //           // color: Pallete.primary,
                  //           fontFamily: 'Nunito',
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 26)),
                  //   onTap: () async {
                  //     // _imgFromCamera();
                  //     Navigator.of(context).pop();
                  //     // await onImageButtonPressed(model, ImageSource.camera);
                  //   },
                  // ),
                  // SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
  }
  Future<void> onImageButtonPressed(MainModel model, ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 100);

      setState(() {
        _imageFile = pickedFile!;
      });

      if (pickedFile != null) {
        _timer?.cancel();
        await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

        FormData formData = FormData.fromMap({
          'name': model.user.name,
          'email': model.user.email,
          'image': await MultipartFile.fromFile(
            _imageFile.path,
            filename: _imageFile.path.split('/').last,
          ),
        });

        Map response = await model.editProfile(formData);

        if (response['error'] == true) {
          print("Edit profile error: ${response['message']}");
          // Show error dialog/snackbar
        } else {
          print("Profile updated successfully");
          await EasyLoading.dismiss();
        }
      }
    } catch (e) {
      if(e.toString() == 'Null check operator used on a null value') {
              // Show Snackbar when the specific exception is caught
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Container(
                    padding: EdgeInsets.all(16.0), // Padding inside the Snackbar
                    decoration: BoxDecoration(
                      color: Colors.red, // Background color
                      borderRadius: BorderRadius.circular(16.0), // Round shape border
                    ),
                    child: const Center(
                      child: Text(
                        "Please select an image",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating, // Optional: make Snackbar floating
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.transparent, // Make default background transparent
                ),
              );
            }else{
              if (kDebugMode) {
                print('hani: $e');
              }
              _showPermanentDenialDialog(context);

            }
            _timer?.cancel();
            await EasyLoading.dismiss();

            setState(() {
              _pickImageError = e;
            });
    } finally {
      _timer?.cancel();
      await EasyLoading.dismiss();
    }
  }


// Future<void> onImageButtonPressed(MainModel model, ImageSource source) async {
  //   // if (_controller != null) {
  //   //   await _controller.setVolume(0.0);
  //   // }
  //   // if (isVideo) {
  //   //   final PickedFile file = await _picker.getVideo(
  //   //       source: source, maxDuration: const Duration(seconds: 10));
  //   //   await _playVideo(file);
  //   // } else {
  //   // await _displayPickImageDialog(context,
  //   //     (double maxWidth, double maxHeight, int quality) async {
  //
  //   try {
  //     final pickedFile = await _picker.pickImage(
  //       source: source,
  //       // maxWidth: 100,
  //       // maxHeight: 100,
  //       imageQuality: 100,
  //     );
  //     setState(() {
  //       _imageFile = pickedFile!;
  //     });
  //     //
  //     late FormData formData;
  //     late dynamic response;
  //     //
  //     if (pickedFile != null) {
  //       _timer?.cancel();
  //       await EasyLoading.show(maskType: EasyLoadingMaskType.custom);
  //
  //       formData = FormData.fromMap({
  //         'name': model.user.name,
  //         'email': model.user.email,
  //         'image': await MultipartFile.fromFile(_imageFile.path,
  //             filename: _imageFile.path.split('/').last)
  //       });
  //
  //       response = await model.editProfile(formData);
  //
  //       if (response['data'] != null) {
  //         _timer?.cancel();
  //         await EasyLoading.dismiss();
  //       }
  //     }
  //     if(pickedFile==null){
  //       if (kDebugMode) {
  //         print('null image');
  //       }
  //     }
  //   } catch (e) {
  //     if(e.toString() == 'Null check operator used on a null value') {
  //       // Show Snackbar when the specific exception is caught
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Container(
  //             padding: EdgeInsets.all(16.0), // Padding inside the Snackbar
  //             decoration: BoxDecoration(
  //               color: Colors.red, // Background color
  //               borderRadius: BorderRadius.circular(16.0), // Round shape border
  //             ),
  //             child: Center(
  //               child: Text(
  //                 "Please select an image",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.white, // Text color
  //                 ),
  //               ),
  //             ),
  //           ),
  //           behavior: SnackBarBehavior.floating, // Optional: make Snackbar floating
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Colors.transparent, // Make default background transparent
  //         ),
  //       );
  //     }else{
  //       if (kDebugMode) {
  //         print('hani: $e');
  //       }
  //       _showPermanentDenialDialog(context);
  //
  //     }
  //     _timer?.cancel();
  //     await EasyLoading.dismiss();
  //
  //     setState(() {
  //       _pickImageError = e;
  //     });
  //   }
  //   // });
  // }
}
