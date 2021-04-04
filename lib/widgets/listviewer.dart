
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/main.dart';




class ListToDoList extends StatefulWidget {
  ListToDoList({Key key}) : super(key: key);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListToDoList> {
  final name = "Name";
  CollectionReference users = FirebaseFirestore.instance.collection('toDoList');
  bool done;
  List _menuItem;
  List  menuItems =  ['item 1'];
  void check() {
    print(menuItems);
    setState(() {
      menuItems.insert(0,"");
    });
    }

  Future <void>firebase(String nameList)  {
    setState(() {
      done=true;
    });
    return users
        .add({
      'todo': nameList, // John Doe
      'check':true,
    }).then((value) => print("List Added"))
        .catchError((error) => print("Failed to add user: $error"));




  }
  Future <void>firebaseNull()  {
    print("Test 3");
    String nameList=" ";
    return users
        .add({
      'todo': nameList, // John Doe
      'check':false
    })

        .then((value) => print("List Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  Future<void> updateList(String nameList,String document) {
    print("dwd");
    return users
        .doc(document)
        .set({'todo': nameList})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteData(String id,int index) {
    return users
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }


  @override
  Widget build(BuildContext context) {
  CollectionReference users = FirebaseFirestore.instance.collection('toDoList');
  return StreamBuilder<QuerySnapshot>(
  stream: users.snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasError) {
    print("hi");
  return Text('Something went wrong');

  }

  if (snapshot.connectionState == ConnectionState.waiting) {
  print(users.snapshots());
  return Text("Loading");

  }
  return ListView.builder(shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (_, int index){
      print(snapshot.data.docs.length);
      DocumentSnapshot document=snapshot.data.docs[index];
       return  Dismissible(key:ObjectKey(document.data().keys),
           background:Container(color:Colors.red),
           secondaryBackground:Container(color:Colors.green),
        onDismissed: (DismissDirection direction){
          if(direction==DismissDirection.startToEnd){
            deleteData(document.id,index);
        }else{
            firebase(document.data()['todo']);
            deleteData(document.id,index);

          }
         },
      child:Column(
        children: <Widget>[
      GestureDetector(
      onVerticalDragStart: (details) {

        if(index==0) {
          check();
          firebaseNull();
        }

      },

        child: Container(
          child:ListTile(leading:document.data()['check']?Icon(Icons.check):null,
        title: TextField(onSubmitted:(value)
        {
        check();
        updateList(value,document.id);
        },decoration:InputDecoration(hintText:document.data()['todo']),
        style: Theme.of(context).textTheme.headline4),
        ),


      ))],
      ));
      });

  return  ListView(
  children: snapshot.data.docs.map((DocumentSnapshot document)  {
    return  ListView.builder(
            shrinkWrap: true,
            itemCount: document.data().length,
            itemBuilder: (_, int index) {
              return Column(
               children:<Widget>[
                  GestureDetector(
                    onVerticalDragStart: (details) {

                      if(snapshot.data.docs[index] == 0) {
                        check();
                        firebaseNull();
                      }

                    },
                    child: ListTile(
                      title: TextField(onSubmitted:(value)
                      {
                        print(document.data().length);

                        print("test"+index.toString());
                        print("hola " + document.data().length.toString());
                        check();

                           updateList(value,document.id);
              },decoration:InputDecoration(hintText:index.toString()),
                          style: Theme.of(context).textTheme.headline4),
                    ),
                  ),
                  Divider(
                    thickness: 2.0,
                  )

                ],
              );
            });
  }).toList(),
  );
  },
  );
  }


  // Widget build(BuildContext context) {
  // return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: menuItems.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Column(
  //           children: [
  //             GestureDetector(
  //               onVerticalDragStart: (details) {
  //                 if(index==0) {
  //                   print('hi');
  //                   check();
  //
  //                 }
  //
  //               },
  //               child: ListTile(
  //                 title: TextField(onSubmitted:(value)  {
  //                      firebase(value);
  //         },decoration:InputDecoration(hintText: "Enter a Text"),
  //                     style: Theme.of(context).textTheme.headline4),
  //               ),
  //             ),
  //             Divider(
  //               thickness: 2.0,
  //             )
  //           ],
  //         );
  //       });
  //
  // }



  
  
  
}


