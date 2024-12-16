import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ns_apps/screens/searchDetail_screen.dart';

String capitalizeEachWord(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

class MakananSearchDelegate extends SearchDelegate<String> {
  final CollectionReference makananRef = FirebaseFirestore.instance.collection('makanan');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green, // Sesuaikan dengan tema aplikasi
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Cari makanan...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(
        child: Text('Ketik nama makanan yang ingin dicari'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: makananRef
          .orderBy('nama_makanan')
          .startAt([capitalizeEachWord(query)])
          .endAt(['${capitalizeEachWord(query)}\uf8ff'])
          .snapshots(),
      builder: (context, snapshot) {
        print('Query: ${capitalizeEachWord(query)}');
        print('Snapshot has data: ${snapshot.hasData}');
        print('Number of documents: ${snapshot.data?.docs.length}');
    
        if (snapshot.hasError) {
          return const Center(child: Text('Terjadi kesalahan'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Tidak ada makanan ditemukan'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var makanan = snapshot.data!.docs[index];
            return ListTile(
              leading: const Icon(Icons.fastfood),
              title: Text(makanan['nama_makanan']),
              subtitle: Text('${makanan['karbohidrat']} g'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchDetailScreen(
                      makananId: makanan.id,
                      makananData: makanan.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}