import 'package:blog_app_new/services/crud.dart';
import 'package:blog_app_new/views/add_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CrudMethods crudMethods = new CrudMethods();

  QuerySnapshot blogSnapshot;

  @override
  void initState() {
    crudMethods.getData().then((result) {
      blogSnapshot = result;
      setState(() {});
    });
    super.initState();
  }

  Widget blogsList() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 24),
        itemCount: blogSnapshot.docs.length,
        itemBuilder: (context, index) {
          return BlogTile(
            author: blogSnapshot.docs[index].get('author'),
            title: blogSnapshot.docs[index].get('title'),
            desc: blogSnapshot.docs[index].get('desc'),
            imgUrl: blogSnapshot.docs[index].get('imgUrl'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
      ),
      body: Container(
          child: blogSnapshot != null
              ? blogsList()
              : Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBlog()));
        },
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc, author;
  BlogTile(
      {@required this.author,
      @required this.desc,
      @required this.imgUrl,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 2),
          Text(
            '$desc - By $author',
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
