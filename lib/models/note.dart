class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });
}


List<Note> sampleNotes = [
  Note(
    id: 0,
    title: 'Christian James V. Torres',
    content:
        'A 24 Year-Old Student of BSCS in Notre Dame of Tacurong College',
    modifiedTime: DateTime(2022,1,1,34,5),
  ),
  Note(
    id: 1,
    title: 'Michael Angelo Zara',
    content:
        'A BSCS Student From Lambayong, SUltan Kudarat',
    modifiedTime: DateTime(2022,1,1,34,5),
  ),

];
