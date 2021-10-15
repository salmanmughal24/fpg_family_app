import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/watch_section.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helper/colors.dart';
import 'helper/utils.dart';
import 'model/product.dart';


class SeeAll extends StatefulWidget {
  String id;
  String categoryName;
  SeeAll({required this.id, required this.categoryName});

  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryData() {
    return FirebaseFirestore.instance.collection("categories").snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getProductData(id) {
    return FirebaseFirestore.instance.collection("products").where('category',isEqualTo:id).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(

        appBar: AppBar(
        //  foregroundColor: Colors.black54,
          backgroundColor: clr_black,
          title: Text(
            widget.categoryName,
            style: label_appbar(),
          ),
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(child: Icon(Icons.arrow_back_ios_outlined, size:15,color: Colors.white,))),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.only(bottom:30.0, top: 30.0),
            child: SizedBox(
              height: _height,
              width: _width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child:StreamBuilder<
                    QuerySnapshot<Map<String, dynamic>>>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<
                          QueryDocumentSnapshot<
                              Map<String, dynamic>>> list =
                          snapshot.data!.docs;
                      List<Product> productList = list
                          .map((e) => Product.fromJson(e.data()))
                          .toList();
                      return      GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 20),
                    itemCount: productList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      Product product =
                      productList.elementAt(index);
                      return CustomCard(
                        title: product.title,
                        thumbnail: product.thumbnail,
                        videoUrl: product.url,
                          onTap: () { /*Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoPlayer(videooUrl:product.url)));*/ },

                      );
                    });
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.pink));
                    }
                  },
                  stream: getProductData(widget.id),)
               /* GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 20),
                    itemCount: 14,
                    itemBuilder: (BuildContext ctx, index) {
                      return CustomCard(
                        title: "Songs Title",
                        thumbnail: Images.songImage,
                        videoUrl: "",
                        onTap: () {},
                      );
                    }),*/


              ),
            ),
          ),
        ));
  }
}