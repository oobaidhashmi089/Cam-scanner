import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyAppp extends StatefulWidget {
  @override
  _MyApppState createState() => _MyApppState();
}

class _MyApppState extends State<MyAppp> {
  File? file;
  ImagePicker image = ImagePicker();
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(img!.path);
    });
  }

  getImagecam() async {
    var img = await image.pickImage(source: ImageSource.camera);

    setState(() {
      file = File(img!.path);
    });
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, file) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    final showimage = pw.MemoryImage(file.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Image(showimage, fit: pw.BoxFit.contain),
          );
          // IconButton(
          //     onPressed: () {
          //       pdf.save();
          //     },
          //     icon: const Icon(Icons.save));
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(" WEB FUN pdf maker"),
          actions: [
            IconButton(
              onPressed: getImage,
              icon: Icon(Icons.image),
            ),
            IconButton(
              onPressed: getImagecam,
              icon: Icon(Icons.camera),
            ),
          ],
        ),
        body: file == null
            ? Container()
            : PdfPreview(
                build: (format) => _generatePdf(format, file),
              ),
      ),
    );
  }
}
