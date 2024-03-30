import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<dynamic> news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  final commonParams = {
    "lang": "en",
    "sort_by": "date",
    "topic": "travel",
    "page_size": "20",
    "page": "1",
  };

Future<void> fetchNews() async {
  try {
    const apiKey = "KNYKNyVwCPOB-hdJPcNtPTwhL8UD9ZX2zv1d5ov2M30";
    const apiUrl = "https://api.newscatcherapi.com/v2/search";
    const queryString = "travel safety";
    final params = {
      ...commonParams,
      "q":
          "($queryString)" 
          // AND (welcomed OR celebrated OR loved OR succeeded OR joyful OR victorious OR flourished OR thrived OR admired OR honored OR delighted OR enthusiastic OR grateful OR content OR excited OR happy OR optimistic OR radiant OR triumphant OR prosperous OR killed OR robbed OR arrested OR hated OR failed OR rejected OR betrayed OR suffered OR lost OR misfortune OR despair OR depressed OR miserable OR abandoned OR lonely OR defeated OR desperate OR forsaken OR ruined OR wretched)",
    };

    final uri = Uri.parse(apiUrl).replace(queryParameters: params);
    final response = await http.get(uri, headers: {"x-api-key": apiKey});

    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body);
      setState(() {
        news = parsedResponse['articles'].map((article) => {
          'title': article['title'],
          'description': article['summary'],
          'url': article['link'],
          'urlToImage': article['media'],
        }).toList();
      });
    } else {
      throw Exception('Failed to load news');
    }
  } catch (error) {
    // ignore: avoid_print
    print(error);
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("News",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff))),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: news.length,
            itemBuilder: (BuildContext context, int index) {
              final article = news[index];
              return NewsCard(
                newsUrl: article['url'],
                imageUrl: article['urlToImage'] ?? "",
                title: article['title'] ?? "",
                description: article['description'] ?? "",
              );
            },
          ),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String newsUrl;

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.newsUrl,
  });

  Future<void> _launchURL(String url, context) async {
    try {
      final Uri url0 = Uri.parse(url);
      await launchUrl(url0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Error : Cannot open the News Article"),
        ),
      );
    }
  }

  String truncateDescription(String description, int cutOff) {
    var words = description.split(' ');
    if (words.length <= cutOff) {
      return description;
    }
    return '${words.sublist(0, cutOff).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchURL(newsUrl, context);
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 90,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 90.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text(
                      truncateDescription(description, 10),
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xccffffff),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
