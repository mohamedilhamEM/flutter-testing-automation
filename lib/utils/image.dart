import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// A service provider for image utilities.
///
/// This class provides methods for picking and taking images using the device's camera or gallery.
/// It uses the `image_picker` package to handle image selection.
class AppImageUtils {

  AppImageUtils._() {
    _init();
  }
  static AppImageUtils? _instance;

  static AppImageUtils get instance {
    _instance ??= AppImageUtils._();
    return _instance!;
  }
  
  /// Initializes the image picker platform and sets the Android photo picker option if the platform is Android.
  void _init() {
    final imagePickerPlatform = ImagePickerPlatform.instance;
    if (imagePickerPlatform is ImagePickerAndroid) {
      imagePickerPlatform.useAndroidPhotoPicker = true;
    }
  }

  /// Picks an image from the gallery.
  /// Returns the selected image file as an [XFile] object.
  Future<XFile?> pickImage() async {
    return ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// Takes an image using the camera.
  /// Returns the captured image file as an [XFile] object.
  Future<XFile?> takeImage() async {
    return ImagePicker().pickImage(source: ImageSource.camera);
  }
}
