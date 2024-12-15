import 'package:flutter/material.dart';
import '../model/articles_model.dart'; 
import '../constants/articles_data.dart'; 

// Halaman daftar artikel
class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Articles',
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 20,
           
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white, 
      ),
      backgroundColor: Colors.green, 
    ),
    body: ListView.builder(
      itemCount: articlesData.length,
      itemBuilder: (context, index) {
        final article = articlesData[index];
        return _buildArticleCard(article);
        },
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
          child: Image.asset(
            article.imagePath,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.justify,
                maxLines: 100,
                overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}