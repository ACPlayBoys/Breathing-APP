import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

List<int>? generateGIF(Iterable<Image> images) {
  final Animation animation = Animation();
  for (Image image in images) {
    animation.addFrame(image);
  }
  return encodeGifAnimation(animation, samplingFactor: 4);
}

Future<File> genrategiff(List<XFile> fu) async {
  List<XFile> imageFiles = fu;

  print(fu);
  final JpegDecoder decoder = JpegDecoder();
  final List<Image> images = [];
  for (var imgFile in imageFiles) {
    Uint8List data = await imgFile.readAsBytes();
    images.add(decoder.decodeImage(data)!);
    print(data);
  }
  print(await Permission.storage.request());
  Directory? appDocDirectory = await getExternalStorageDirectory();

  List<int>? gifData = generateGIF(images);
  String path = appDocDirectory!.path + "/this.gif";
  print(path);
  File f = File(path)..writeAsBytes(gifData!);
  return f;
}
