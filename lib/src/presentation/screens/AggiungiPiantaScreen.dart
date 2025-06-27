import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

import '../../data/models/PiantaModel.dart';
import '../../data/models/CategoriaModel.dart';
import '../../data/models/SpecieModel.dart';
import '../../domain/PianteRepository.dart';
import '../../domain/CategorieRepository.dart';
import '../../domain/SpecieRepository.dart';

class AggiungiPiantaScreen extends StatefulWidget {
  @override
  _AggiungiPiantaScreenState createState() => _AggiungiPiantaScreenState();
}

class _AggiungiPiantaScreenState extends State<AggiungiPiantaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  DateTime _dataAcquisto = DateTime.now();
  Uint8List? _foto;
  int? _idSpecie;
  int? _idCategoria;
  String _stato = 'Sana';

  List<Specie> _specieDisponibili = [];
  List<Categoria> _categorieDisponibili = [];

  @override
  void initState() {
    super.initState();
    _caricaSpecieECategorie();
  }

  Future<void> _caricaSpecieECategorie() async {
    final specie = await SpecieRepository.instance.getTutteLeSpecie();
    final categorie = await CategorieRepository.instance.getTutteLeCategorie();
    setState(() {
      _specieDisponibili = specie;
      _categorieDisponibili = categorie;
    });
  }

  Future<void> _selezionaData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataAcquisto,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() => _dataAcquisto = data);
    }
  }
/* Da capire come gestire immagini
  Future<void> _selezionaFoto() async {
    final picker = ImagePicker();
    final immagine = await picker.pickImage(source: ImageSource.gallery);
    if (immagine != null) {
      final bytes = await immagine.readAsBytes();
      setState(() => _foto = bytes);
    }
  }
*/
  Future<void> _salvaPianta() async {
    if (_formKey.currentState!.validate() && _idSpecie != null && _idCategoria != null) {
      final nuovaPianta = Pianta(
        id: null,
        nome: _nomeController.text,
        dataAcquisto: _dataAcquisto,
        foto: _foto,
        frequenzaInnaffiatura: 0,
        frequenzaPotatura: 0,
        frequenzaRinvaso: 0,
        note: null,
        stato: _stato,
        idSpecie: _idSpecie!,
      );

      final repo = PianteRepository();
      await repo.aggiungiPianta(nuovaPianta);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aggiungi Pianta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome della pianta'),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci un nome' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _idSpecie,
                items: _specieDisponibili.map((specie) {
                  return DropdownMenuItem<int>(
                    value: specie.id,
                    child: Text(specie.nome),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _idSpecie = val),
                decoration: InputDecoration(labelText: 'Specie'),
                validator: (val) => val == null ? 'Seleziona una specie' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _idCategoria,
                items: _categorieDisponibili.map((categoria) {
                  return DropdownMenuItem<int>(
                    value: categoria.id,
                    child: Text(categoria.nome),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _idCategoria = val),
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (val) => val == null ? 'Seleziona una categoria' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Data di acquisto: ${_dataAcquisto.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _selezionaData,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _stato,
                items: ['Sana', 'Da controllare', 'Malata'].map((stato) {
                  return DropdownMenuItem<String>(
                    value: stato,
                    child: Text(stato),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _stato = val!),
                decoration: InputDecoration(labelText: 'Stato'),
              ),
              const SizedBox(height: 16),
              /*
              ElevatedButton(
                onPressed: _selezionaFoto,
                child: Text('Seleziona una foto'),
              ),
              */
              if (_foto != null) ...[
                const SizedBox(height: 8),
                Image.memory(_foto!, height: 150),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvaPianta,
                child: Text('Salva Pianta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
