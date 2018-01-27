import 'package:setnote_flutter/local_database.dart';
import 'package:test/test.dart';



void main() {
test('test dei test', () {
    var answer = 42;
    expect(answer, 42);
  });

 test('checkTextColor unity test', () {
     var team =<String, dynamic> {"ultimaModifica":"123455","key":"chiavesecondasquadra","stagione":"2018","categoria":"Serie X Femminile","nome":"Vattelapesca","coloreMaglia":"Color(0xff214d82)","allenatore":"allenatore2","assistente":"assistente2"};
    LocalDB.addTeam(team);
    var key= "chiavesecondasquadra";
    var answer = LocalDB.getTeamByKey(key);
   
    expect(answer, team);
  });

}