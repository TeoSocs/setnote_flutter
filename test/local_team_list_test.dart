import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:setnote_flutter/local_team_list.dart';



void main() {
test('test dei test', () {
    var answer = 42;
    expect(answer, 42);
  });

 test('checkTextColor unity test', () {
     var team =<String, dynamic> {"ultima_modifica":"123455","key":"chiavesecondasquadra","stagione":"2018","categoria":"Serie X Femminile","nome":"Vattelapesca","colore_maglia":"Color(0xff214d82)","allenatore":"allenatore2","assistente":"assistente2"}; 
    LocalDB.add(team);
    var key= "chiavesecondasquadra";
    var answer = LocalDB.getByKey(key);
   
    expect(answer, team);
  });

}