import 'package:flutter/material.dart';
import 'package:flutter_res/helpers/style.dart';
import 'package:flutter_res/providers/app.dart';
import 'package:flutter_res/providers/category.dart';
import 'package:flutter_res/providers/product.dart';
import 'package:flutter_res/providers/user.dart';
import 'package:flutter_res/widgets/custom_file_button.dart';
import 'package:flutter_res/widgets/customtext.dart';
import 'package:flutter_res/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
   final productprovider = Provider.of<ProductProvider>(context);
   final categoryprovider = Provider.of<CategoryProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
   final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: white,
          title: Text(
            "Add Product",
            style: TextStyle(color: black),
          )),
      body:appProvider.isLoading ? Loading(): ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                   Container(

                     child:productprovider.productImage != null?
                     CustomFileUploadButton(
                       icon: Icons.image,
                        text: "Add image",
                      onTap: () async {
 //                      productprovider.loadImageFile();
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext bc){
                              return Container(
                                child: new Wrap(
                                  children: <Widget>[
                                    new ListTile(
                                        leading: new Icon(Icons.image),
                                        title: new Text('Gallery'),
                                        onTap: () async {
                                          productprovider.getImageFile( ImageSource.gallery);
                                          Navigator.pop(context);
                                        }
                                    ),
                                    new ListTile(
                                      leading: new Icon(Icons.camera_alt),
                                      title: new Text('Camera'),
                                      onTap: () async { productprovider.getImageFile( ImageSource.camera);
                                      Navigator.pop(context);
                                      }
                                    ),
                                  ],
                                ),
                              );
                            }
                        );


//                      itemProvider.loadCoverFile();
                      },
                  ):

              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                      child: Image.file(productprovider.productImage)),
                 
                ],
              ),
                   ),



//                    Visibility(
//                      visible: itemProvider.coverFile != null,
//                      child: Positioned(
//                        bottom: 20,
//                        right: 50,
//                        child: Align(
//                            alignment: Alignment.bottomCenter,
//                            child: CustomText(
//                              text: "${itemProvider.coverFileName} added",
//                              size: 10,
//                              color: green,
//                            )),
//                      ),
//                    )
                  ],
                ),
            ),
          Visibility(
            visible: productprovider.productImage != null,
            child: FlatButton(onPressed:() {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return Container(
                      child: new Wrap(
                        children: <Widget>[
                          new ListTile(
                              leading: new Icon(Icons.image),
                              title: new Text('Gallery'),
                              onTap: () async {
                                productprovider.getImageFile(ImageSource.gallery);
                                Navigator.pop(context);
                              }
                          ),
                          new ListTile(
                              leading: new Icon(Icons.camera_alt),
                              title: new Text('Camera'),
                              onTap: () async {
                                productprovider.getImageFile(ImageSource.camera);
                                Navigator.pop(context);
                              }
                          ),
                        ],
                      ),
                    );
                  });
            },

         child: CustomText(text: "Change image",color: primary,)),
          ),
          Divider(),
          Padding(
              padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomText(text: "featured Magazine"),
                  Switch(
                      value:productprovider.featured,
                      onChanged: (value) {
                        productprovider.changeFeatured();
                      })
                ],
              )),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CustomText(text: "Category:", color: grey, weight: FontWeight.w300,),
              DropdownButton<String>(
                value: categoryprovider.selectedCategory,
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w300
                ),
                icon: Icon(Icons.filter_list,
                  color: primary,),
                elevation: 0,
                onChanged: (value){
                  categoryprovider.changeSelectedCategory(newCategory: value.trim());
                },
                items:categoryprovider.categoriesNames.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value));
                }).toList(),

              ),
            ],
          ),
          Divider(),
          Padding(
            padding:
            const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: black, width: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.5),
                        offset: Offset(2, 7),
                        blurRadius: 7)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: TextField(
                  controller: productprovider.name,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Product name",
                      hintStyle: TextStyle(
                          color: grey, fontFamily: "Sen", fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: black, width: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.5),
                        offset: Offset(2, 7),
                        blurRadius: 7)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: TextField(
                  controller: productprovider.description,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Product description",
                      hintStyle: TextStyle(
                          color: grey, fontFamily: "Sen", fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: black, width: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.5),
                        offset: Offset(2, 7),
                        blurRadius: 7)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: TextField(
                  controller: productprovider.price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Price",
                      hintStyle: TextStyle(
                          color: grey, fontFamily: "Sen", fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
                decoration: BoxDecoration(
                    color: primary,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.3),
                          offset: Offset(2, 7),
                          blurRadius: 4)
                    ]),
                child: FlatButton(
                  onPressed: () async{
                    appProvider.changeLoading();
                    if(! await productprovider.uploadProduct(
                      category: categoryprovider.selectedCategory,
                      restaurantId: userProvider.restaurant.id,
                      restaurant: userProvider.restaurant.name,
                    )) {

                      _key.currentState.showSnackBar(
                          SnackBar(content: Text(" Upload Failed"),
                            duration: const Duration(seconds: 10),
                          ));
                      appProvider.changeLoading();
                    return;
                    }
                    productprovider.clear();
                    _key.currentState.showSnackBar(
                        SnackBar(content: Text(" Uploaded"),
                          duration: const Duration(seconds: 10),
                        ));
                    userProvider.loadProductsByRestaurant(restaurantId: userProvider.restaurant.id);
                    appProvider.changeLoading();
                  },

                  child: CustomText(
                    text: "Post",
                    color: white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}