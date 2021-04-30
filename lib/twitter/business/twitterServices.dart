import 'dart:convert';

import 'package:covid_19/twitter/business/metaData.dart';
import 'package:covid_19/twitter/business/searchModel.dart';
import 'package:http/http.dart' as http;

class TwitterServices {
  static Future<List<Tweetarticle>> getTweets(
      {int offset = 0, String location, String resource}) async {
    String url =
        'https://covidarmy-backend.apoorvsingal.repl.co/api/tweets/$location/$resource?limit=20&offset=$offset';
    var response = await http.get(Uri.parse(url));

    final tweetarticles = tweetarticleFromJson(response.body);
    return tweetarticles;
  }

  static Future<Metadata> getMetaData({String postId}) async {
    String url = 'https://twitter-search.vercel.app/api/get-tweet-ast/$postId';
    var response = await http.get(Uri.parse(url));

    final metadata = metadataFromJson(response.body);
    return metadata[0];
  }
}
