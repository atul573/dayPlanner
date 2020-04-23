import 'package:flutter/material.dart';
import 'dart:async';
import '../database_helper.dart';
import '../Note.dart';
import 'note_detail.dart';
import 'package:sqflite/sqflite.dart';
class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
      
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Day Planner"),
        backgroundColor: Colors.purple,

      ),
      body: getNoteListView(),



      floatingActionButton: FloatingActionButton(onPressed:(){
        navigateToDetail(Note('','',2), 'Add Note');
      } ,
      
      backgroundColor: Colors.purple,
      child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView(){

    return ListView.builder(
      itemCount: count,
      itemBuilder:(context, position){
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.deepPurple,
          elevation: 4.0,
          child: ListTile(
            leading: Icon(Icons.list),
            title: Text(this.noteList[position].title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.00,

            ),
            ),
            subtitle: Text(this.noteList[position].date,
            style: TextStyle(
              color: Colors.white,
              

            ),
            
            
            ),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new, color: Colors.white),
              onTap:(){
                 navigateToDetail(this.noteList[position], 'Edit ToDo');
              }
            ),



          ),
        );

      } );
  }

  void navigateToDetail(Note note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(title, note);
	  }));

    if(result== true){
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });


      });
    });


  }
}