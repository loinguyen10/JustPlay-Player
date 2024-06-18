// Copyright (c) 2017, rinukkusu. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A dart library for interfacing with the Spotify API.
library spotify;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:pedantic/pedantic.dart';
// import 'package:spotify/spotify.dart';

import '../../model/spotify/_models.dart';

export 'package:oauth2/oauth2.dart' show AuthorizationException, ExpirationException;

export '../../model/spotify/_models.dart';

part 'endpoints/albums.dart';
part 'endpoints/artists.dart';
part 'endpoints/audio_features.dart';
part 'endpoints/browse.dart';
part 'endpoints/categories.dart';
part 'endpoints/endpoint_base.dart';
part 'endpoints/endpoint_paging.dart';
part 'endpoints/episodes.dart';
part 'endpoints/me.dart';
part 'endpoints/player.dart';
part 'endpoints/playlists.dart';
part 'endpoints/recommendations.dart';
part 'endpoints/search.dart';
part 'endpoints/shows.dart';
part 'endpoints/tracks.dart';
part 'endpoints/users.dart';
part 'spotify_api.dart';
part 'spotify_base.dart';
part 'spotify_credentials.dart';
part 'spotify_exception.dart';
part 'utils.dart';
