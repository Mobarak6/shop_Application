import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Authentication.dart';
import 'package:shop_app/widgets/dialog.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';

class UserProductForm extends StatefulWidget {
  static const routeName = '/user_product_form';
  const UserProductForm({Key? key}) : super(key: key);

  @override
  _UserProductFormState createState() => _UserProductFormState();
}

class _UserProductFormState extends State<UserProductForm> {
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageLinkFocusNode = FocusNode();
  //
  var _imageControler = TextEditingController();
  var _titleControler = TextEditingController();
  var _priceControler = TextEditingController();
  var _discriptionControler = TextEditingController();

  var isInit = true;
  var _isLoading = false;

  File? _file = null;
  String? _path;

  @override
  void didChangeDependencies() {
    if (isInit) {
      try {
        Product product = ModalRoute.of(context)?.settings.arguments as Product;
        _titleControler = TextEditingController(text: product.title);
        _imageControler = TextEditingController(text: product.imageUrl);
        _discriptionControler =
            TextEditingController(text: product.description);
        _priceControler = TextEditingController(text: product.price.toString());
      } catch (e) {}
    }

    isInit = false;

    super.didChangeDependencies();
  }

  Future<void> getImagePicker() async {
    final ImagePicker _imagePicker = ImagePicker();
    final _xFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _path = _xFile!.path;
      _file = File(_path!);
      // log(_path!);
    });
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageLinkFocusNode.dispose();
    //
    _imageControler.dispose();
    _titleControler.dispose();
    _priceControler.dispose();
    _discriptionControler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _getSize = MediaQuery.of(context).size;
    log('User Form');

    return Scaffold(
        appBar: AppBar(
          title: Text('Form'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SingleChildScrollView(
                        child: Row(
                          //for flax fixing
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    //initialValue: "Its init value",
                                    controller: _titleControler,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_priceFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Title',
                                    ),
                                  ),
                                  SizedBox(
                                    height: _getSize.height * 0.02,
                                  ),
                                  TextFormField(
                                    controller: _priceControler,
                                    focusNode: _priceFocusNode,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_discriptionFocusNode);
                                      //_priceFocusNode.dispose();
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Price',
                                    ),
                                  ),
                                  SizedBox(
                                    height: _getSize.height * 0.02,
                                  ),
                                  TextFormField(
                                    controller: _discriptionControler,
                                    focusNode: _discriptionFocusNode,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_imageLinkFocusNode);
                                      //_discriptionFocusNode.dispose();
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Discription',
                                    ),
                                  ),
                                  SizedBox(
                                    height: _getSize.height * 0.05,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _file == null
                                          ? Container(
                                              child: _imageControler
                                                      .text.isEmpty
                                                  ? Center(
                                                      child:
                                                          Text('Submit Image'))
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          Colors.amber,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        _imageControler.text,
                                                      ),

                                                      //backgroundImage: Image.asset(name),
                                                    ),
                                              height: _getSize.height * 0.15,
                                              width: _getSize.width * 0.25,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blueGrey,
                                                      width: 2)),
                                            )
                                          : CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  FileImage(_file!),

                                              //child: Image.file(_file!),
                                            ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: _imageLinkFocusNode,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.url,
                                          controller: _imageControler,
                                          decoration: InputDecoration(
                                            ///hintText: 'Image Link',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            labelText: 'Image Link',
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: getImagePicker,
                                          icon: Icon(Icons.camera_alt_rounded))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          Product product = ModalRoute.of(context)
                              ?.settings
                              .arguments as Product;

                          Provider.of<Products>(context, listen: false)
                              .upDateItem(
                                  Provider.of<Authentication>(context,
                                      listen: false),
                                  product.id,
                                  Product(
                                    description: _discriptionControler.text,
                                    id: product.id,
                                    userId: Provider.of<Authentication>(context,
                                            listen: false)
                                        .userId,
                                    imageUrl: _imageControler.text,
                                    price: double.parse(_priceControler.text),
                                    title: _titleControler.text,
                                    isFavorite: product.isFavorite,
                                  ))
                              .then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                          }).catchError((_) {
                            DialogView.DialogViewFun(
                                    context, 'Something Wrong!')
                                .then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                            //dialogShow(context);
                          });
                        } catch (e) {
                          Provider.of<Products>(context, listen: false)
                              .addItem(
                            _titleControler.text,
                            _discriptionControler.text,
                            double.parse(_priceControler.text),
                            _imageControler.text,
                            Provider.of<Authentication>(context, listen: false)
                                .idToken,
                            Provider.of<Authentication>(context, listen: false)
                                .userId,
                          )
                              .then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                          }).catchError((error) {
                            DialogView.DialogViewFun(
                                    context, 'Something Wrong!')
                                .then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                            //dialogShow(context);
                          });
                        }
                      },
                      icon: const Icon(Icons.done),
                      label: const Text('Done'),
                    ),
                  ),
                ],
              )));
  }
}
