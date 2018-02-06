import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Manuale'),
      content: new Text('''
---Nuova partita---

Da qui puoi creare una nuova partita.
Inizialmente scegli la squadra per la quale vuoi raccogliere i dati.
Successivamente inserisci le informazioni riguardo la partita e vai alla schermata di raccolta.
Per registrare un fondamentale devi premere il nome di un giocatore, il nome del fondamentale e l'esito (in questo ordine).
I fondamentali vengono salvati nella colonna a sinistra.
Alla fine dell'azione premi V se la tua squadra ha fatto punto o X altrimenti.
Per correggere il punteggio tieni premuto il contatore.

---Archivio partite---

L'archivio delle partite salvate in locale delle quali hai raccolto i dati.
Selezionandone una potrai vederne le statistiche.

---Gestione squadra---

Mostra tutte le squadre salvate in locale.
Con "Squadre nel cloud" vengono mostrate le squadre presenti nel cloud e il loro stato di sincronizzazione.
Con l'action button viene mostrato un elenco delle squadre locali. Selezionandone una, questa viene aggiunta al cloud.

---Statistiche squadra---

Da qui puoi visualizzare le statistiche relative a una squadra.
Seleziona dall'elenco la squadra che ti interessa.
Puoi filtrare le statistiche per giocatore selezionandone uno dall'elenco sulla sinistra

---Legenda colori:---

Blu -> ottimo
Verde -> buono
Giallo -> scarso
Rosso -> pessimo
      '''
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Chiudi'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}