

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Screen1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Screen1State();
  }

}
late var url;

bool c=true;
int selectedOption=1;



var urlController=TextEditingController();
TextEditingController forbookmark=TextEditingController();
class Screen1State extends State<Screen1>{
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    pullToRefreshController=kIsWeb?null:PullToRefreshController(
      onRefresh: () async{
        if(defaultTargetPlatform==TargetPlatform.android){
          inAppWebViewController?.reload();
        }
        else if(defaultTargetPlatform==TargetPlatform.iOS){
          inAppWebViewController?.loadUrl(urlRequest: URLRequest(url:await inAppWebViewController?.getUrl()));
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    var initialurl = "https://www.google.com/";
    // TODO: implement build

    return Consumer(
        builder: (context, changes provider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                PopupMenuButton<int>(
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_border),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton(child: Text("All BookMark",
                            style: TextStyle(color: Colors.black),),
                            onPressed: ()async {


                              showDialog(context: context,anchorPoint: Offset(200, 100) , builder: (context) {
                                return Consumer<changes>(

                                    builder: (context, provider,child)  {
                                      List<String> stringList=provider.stringList;
                                      return Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          width: 370,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:stringList.isNotEmpty? Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Center(child: Text("Your BookMarks",style: TextStyle(color: Colors.black),)),
                                                      IconButton(onPressed: () {
                                                        Navigator.pop(context);
                                                      }, icon: Icon(Icons.cancel_outlined,color: Colors.black,))
                                                    ],
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:stringList.length,
                                                  itemBuilder: (context, index) {
                                                    String value=stringList[index];
                                                    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: 300,height: 20,
                                                            child: GestureDetector(
                                                                onTap: () {},
                                                                child: Text(value))),
                                                        IconButton(onPressed:() => provider.removeStringList(value),
                                                            icon: Icon(Icons.cancel)),
                                                      ],
                                                    );
                                                  },),
                                              ],
                                            ):Center(child: Column(
                                              children: [
                                                Text("You Don't have any Bookmarks Yet."),
                                                TextButton(onPressed:() {
                                                  Navigator.pop(context);
                                                }, child: Text("Close")),
                                              ],
                                            )),
                                          ),
                                        ),
                                      );
                                    }
                                );;
                              },);
                            },)
                        ],
                      ),
                    ),

                  ],
                  offset: Offset(0, 100),
                  elevation: 2,
                ),
              ],
              title: Text("My Browser",
                style: TextStyle(color: Colors.black, fontSize: 20),),

            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: MediaQuery.of(context).size.height,
                    child: Consumer(
                        builder: (context, changes, child) {
                          return InAppWebView(
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (controller) {
                              inAppWebViewController = controller;
                            },
                            onLoadStart: (controller, url) {
                              var v = url.toString();
                              provider.link(v);
                            },
                            onLoadStop: (controller, url) {
                              pullToRefreshController?.endRefreshing();
                            },

                            onLoadError: (controller, url, code, message) {
                              pullToRefreshController?.endRefreshing();
                            },
                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {
                                pullToRefreshController?.endRefreshing();
                              }
                            },
                            initialUrlRequest: URLRequest(url: Uri.parse(initialurl)),
                          );
                        }
                    ),
                  ),
                  Container(height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Consumer(
                          builder: (context,changes,child) {
                            return TextField(
                              controller: urlController,
                              cursorColor: Colors.black,
                              cursorHeight: 20,
                              style: TextStyle(color: Colors.black,fontSize: 18),
                              onSubmitted: (value) {
                                url = Uri.parse(value);
                                if (url.scheme.isEmpty) {
                                  url = Uri.parse("${initialurl}search?q=$value");
                                  print(urlController);
                                }
                                inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: url));
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12),),borderSide: BorderSide(color: Colors.black)),
                                hintText: "Search or type web address",
                                suffixIcon: Icon(Icons.search),
                              ),);
                          }
                        ),
                      ),
                    ),
                  ),
                  Container(height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () async {


                        }, icon: Icon(Icons.home_filled, color: Colors.black,)),
                        Consumer(
                            builder: (context, changes, child) {
                              return IconButton(onPressed: () async {
                                forbookmark.clear();
                                showDialog(
                                  context: context,builder: (context) {
                                  return Center(

                                    child: Material(
                                      child: Container(height: 200, width: 300,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              TextField(
                                                decoration: InputDecoration(
                                                  hintText: urlController.text,
                                                  hintStyle: TextStyle(color: Colors.black),
                                                  border: InputBorder.none,
                                                ),
                                                readOnly: true,
                                              ),
                                              TextField(
                                                controller: forbookmark,
                                                decoration: InputDecoration(
                                                  hintText: "Give name",
                                                  border: InputBorder.none,),
                                              ),
                                              TextButton(onPressed: () {
                                                provider.saveStringList(forbookmark.text);
                                                print(provider.stringList);
                                                Navigator.pop(context);
                                              }, child: Text("Save"))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  );
                                },);
                                provider.colo(c);
                              },
                                  icon: Icon(c ? Icons.bookmark_border : Icons
                                      .bookmark_outlined,
                                    color: Colors.black,));
                            }
                        ),
                        IconButton(onPressed: () {
                          inAppWebViewController?.goBack();
                        }, icon: Icon(
                              Icons.arrow_back_ios, color: Colors.black,)),
                        IconButton(onPressed: () {
                          inAppWebViewController?.reload();
                        }, icon: Icon(Icons.refresh, color: Colors.black,)),
                        IconButton(onPressed: () {
                          inAppWebViewController?.goForward();
                        }, icon: Icon(
                              Icons.arrow_forward_ios, color: Colors.black,)),


                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }




}
class changes extends ChangeNotifier{
  List<String> _stringList=[];
  void link(var v) {
    urlController.text=v;
  }

  void colo(bool i) {
    i=false;
    notifyListeners();
  }




  List<String> get stringList => _stringList;

  void saveStringList(String value)async{
    _stringList.add(value);
    saveStringListToSharedPrefs();
    notifyListeners();
  }

  void removeStringList(String value)async{
    _stringList.remove(value);
    saveStringListToSharedPrefs();
    notifyListeners();
  }

  void saveStringListToSharedPrefs()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setStringList('stringList',_stringList);
  }

  void getStringListFromSharedPrefs()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? storedList=prefs.getStringList('stringList');
    if(storedList != null){
      _stringList=storedList;
    }
    notifyListeners();
  }


}
