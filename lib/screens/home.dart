import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Note> filteredNotes = [];
  bool sorted = false;

  @override
  void initState(){
    super.initState();
    filteredNotes = sampleNotes;
  }

  List<Note>sortNotes(List<Note>notes){
    if(sorted){
      notes.sort((a,b) => a.modifiedTime.compareTo(b.modifiedTime));
    }else{
      notes.sort((b,a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

  sorted = !sorted;

    return notes;
  }

  getRandomColor(){
    // Random random = Random();
    // random.nextInt(backgroundColors.length)
    return backgroundColors[0];
  }

  void  onSearchTextChanged(String searchText){
    setState(() {
      filteredNotes = sampleNotes.where((note) => note.content.toLowerCase().contains(searchText.toLowerCase()) ||
          note.title.toLowerCase().contains(searchText.toLowerCase())).toList();
    });

  }

  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];

      if(sampleNotes.length == 1){
        sampleNotes.removeAt(0);
      }
      sampleNotes.removeWhere((note) => note.id == index);
      filteredNotes.removeWhere((note) => note.id == index);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,40,16,0),
        child:  Column(
             children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Journal App', style: TextStyle(fontSize: 30, color: Colors.white),),
              IconButton(onPressed: (){

               setState(() {
                 filteredNotes = sortNotes(filteredNotes);
               });

              },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.sort, color: Colors.white,
                    ),
          ))
        ],
      ),
               SizedBox(height: 20,),
               TextField(

                 onChanged: onSearchTextChanged,

                 style: TextStyle(fontSize: 16, color: Colors.white),
                 decoration: InputDecoration(
                   contentPadding: EdgeInsets.symmetric(vertical: 12) ,
                   hintText: "Search Journals...",
                   hintStyle: TextStyle(color: Colors.grey),
                   prefixIcon: Icon(Icons.search, color: Colors.grey,),
                   fillColor: Colors.grey.shade800,
                     filled: true,
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(30),
                       borderSide: const BorderSide(color: Colors.transparent),

                     )
                 ),
               ),
               Expanded(
                   child: ListView.builder(
                     padding: EdgeInsets.only(top: 30),
                     itemCount: filteredNotes.length,
                 itemBuilder: (context, index){
                       return
                         Card(
                           margin: EdgeInsets.only(bottom: 20),
                           color: getRandomColor(),
                           elevation: 3,
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10)
                           ) ,
                           child: ListTile(
                             onTap: () async {
                               final result = await Navigator.push(
                                 context,
                                 MaterialPageRoute(builder:
                                 (BuildContext context) =>  EditScreen(note: filteredNotes[index],))
                               );
                               if (result != null){
                                 setState(() {
                                  int originalIndex = sampleNotes.indexOf(filteredNotes[index]);
                                   sampleNotes[originalIndex]=(Note(
                                       id: sampleNotes[originalIndex].id,
                                       title: result[0],
                                       content: result[1],
                                       modifiedTime: DateTime.now()));
                                   filteredNotes [index]=(Note(
                                       id: sampleNotes[originalIndex].id,
                                       title: result[0],
                                       content: result[1],
                                       modifiedTime: DateTime.now()));
                                 });

                               }
                             },
                             title: RichText(
                               maxLines: 3,
                               overflow: TextOverflow.ellipsis,
                               text:  TextSpan(
                                   text: '${filteredNotes[index].title}\n',
                                   style: const TextStyle(
                                       color: Colors.black,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 18,
                                       height: 1.5),
                                   children: [
                                     TextSpan(
                                       text: filteredNotes[index].content,
                                       style: const TextStyle(
                                           color: Colors.black,
                                           fontWeight: FontWeight.normal,
                                           fontSize: 14,
                                           height: 1.5),
                                     )
                                   ]),
                             ),
                             subtitle:Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                               child: Text(''
                                   'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                   style: TextStyle(
                                 fontSize: 10,
                                 fontStyle: FontStyle.italic,
                                 color: Colors.grey.shade800,
                               )),
                             ),
                             trailing: IconButton(
                               onPressed: () async {
                                final result = await confirmDialog(context);
                                    if(result){
                                      deleteNote(index) ;
                                    }

                             }, icon: Icon(Icons.delete,),),
                           ),
                         );
                 },

    ))
                 ],
    ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{
        final result = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => const EditScreen(),
            )
         );

        if (result != null){
          setState(() {
            sampleNotes.add(Note(
                id: sampleNotes.length,
                title: result[0],
                content: result[1],
                modifiedTime: DateTime.now()));
            filteredNotes = sampleNotes;
          });

        }

        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
      child: const Icon(Icons.add, size: 38,),),
    );

  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            icon: Icon(Icons.info, color: Colors.grey),
            title: Text(
              'Are you sure you want to delete this Journal?',
              style: TextStyle(color: Colors.white),
            ),
                                       content: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                         children: [
                                         ElevatedButton(onPressed: (){
                                           Navigator.pop(context, true);
                                         },
                                           style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFCCE5FF)),
                                           child: const SizedBox(
                                             width: 60,
                                           child: Text('Yes',
                                           textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)
                                         ),),
                                         ElevatedButton(onPressed: (){
                                           Navigator.pop(context, false);
                                         },
                                           style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD6D6)),
                                           child: const SizedBox(
                                               width: 60,
                                               child: Text('No',
                                                 textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)
                                           ),)
                                       ],),
                                     );
                                   });
  }
}
