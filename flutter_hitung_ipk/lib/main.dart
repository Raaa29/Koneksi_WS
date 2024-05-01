import 'package:flutter/material.dart'; // Mengimpor library Flutter Material untuk komponen UI
import 'dart:convert'; // Mengimpor library dart:convert untuk pemrosesan JSON

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter dengan widget MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transkrip Mahasiswa', // Judul aplikasi
      initialRoute: '/', // Rute awal aplikasi
      routes: {
        '/': (context) =>
            TranskripNilai(), // Rute untuk tampilan TranskripNilai
        '/ipk': (context) => IPKPage(), // Rute untuk tampilan IPKPage
      },
    );
  }
}

class TranskripNilai extends StatefulWidget {
  @override
  _TranskripNilaiState createState() => _TranskripNilaiState();
}

class _TranskripNilaiState extends State<TranskripNilai> {
  List<dynamic> mataKuliah = []; // Variabel untuk menyimpan data mata kuliah
  String transkripJson = '''
    {
      "nama": "Farraheira Panundaratrisna Fauziah",
      "NIM": "22082010006",
      "semester": 4,
      "mata_kuliah": [
        {"kode": "MK1", "nama": "Pemrograman Mobile", "sks": 3, "nilai": "A-"},
        {"kode": "MK2", "nama": "PKTI", "sks": 3, "nilai": "B+"},
        {"kode": "MK3", "nama": "E-Bisnis", "sks": 3, "nilai": "A-"},
        {"kode": "MK5", "nama": "Kepemimpinan", "sks": 2, "nilai": "A-"},
        {"kode": "MK6", "nama": "Manajemen Proyek Sistem Informasi", "sks": 3, "nilai": "A"},
        {"kode": "MK7", "nama": "Pemograman Website", "sks": 3, "nilai": "A-"},
        {"kode": "MK8", "nama": "Kecakapan Pribadi", "sks": 3, "nilai": "A-"}
      ]
    }
    ''';

  @override
  void initState() {
    super.initState();
    _getTranskripData(); // Memuat data transkrip saat widget diinisialisasi
  }

  void _getTranskripData() {
    Map<String, dynamic> transkrip =
        jsonDecode(transkripJson); // Mendekode JSON menjadi Map

    setState(() {
      mataKuliah = transkrip[
          'mata_kuliah']; // Mengisi daftar mata kuliah dari data transkrip
    });
  }

  double calculateIPK() {
    double totalSKS = 0;
    double totalBobot = 0;

    // Menghitung total SKS dan total bobot nilai
    for (var matkul in mataKuliah) {
      double sks = matkul['sks'];
      totalSKS += sks;

      String nilai = matkul['nilai'];
      double bobot = 0;

      // Mengonversi nilai huruf menjadi bobot numerik
      if (nilai == 'A') {
        bobot = 4.0;
      } else if (nilai == 'A-') {
        bobot = 3.7;
      } else if (nilai == 'B+') {
        bobot = 3.3;
      } else if (nilai == 'B') {
        bobot = 3.0;
      }
      totalBobot += (bobot * sks);
    }

    return totalBobot / totalSKS; // Menghitung IPK
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transkrip Nilai'), // Judul AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama: Farraheira Panundaratrisna Fauziah',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'NPM: 22082010006',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Semester: 4',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Transkrip Nilai:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No')), // Kolom No
                    DataColumn(
                        label:
                            Text('Kode Mata Kuliah')), // Kolom Kode Mata Kuliah
                    DataColumn(label: Text('Mata Kuliah')), // Kolom Mata Kuliah
                    DataColumn(label: Text('SKS')), // Kolom SKS
                    DataColumn(label: Text('Nilai')), // Kolom Nilai
                    DataColumn(label: Text('Semester')), // Kolom Semester
                  ],
                  rows: List.generate(mataKuliah.length, (index) {
                    var matkul = mataKuliah[index];
                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())), // Sel No
                        DataCell(Text(matkul['kode'])), // Sel Kode Mata Kuliah
                        DataCell(Text(matkul['nama'])), // Sel Mata Kuliah
                        DataCell(Text(matkul['sks'].toString())), // Sel SKS
                        DataCell(Text(matkul['nilai'])), // Sel Nilai
                        DataCell(Text('5')), // Sel Semester (konstan 5)
                      ],
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double ipk = calculateIPK(); // Menghitung IPK
                  Navigator.pushNamed(context, '/ipk',
                      arguments: ipk.toStringAsFixed(
                          2)); // Pindah ke halaman IPK dengan nilai IPK sebagai argumen
                },
                child: Text('Hitung IPK'), // Tombol untuk menghitung IPK
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IPKPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ipk = ModalRoute.of(context)?.settings.arguments
        as String?; // Mendapatkan nilai IPK dari argumen

    return Scaffold(
      appBar: AppBar(
        title: Text('IPK'), // Judul AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IPK: ${ipk ?? ""}', // Menampilkan nilai IPK
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Tombol untuk kembali ke halaman sebelumnya
              },
              child: Text('Kembali'), // Teks pada tombol kembali
            ),
          ],
        ),
      ),
    );
  }
}
