# Get Spotify Data
library(spotifyr)
library(tidyverse)

# docs: <https://www.rcharlie.com/spotifyr/>
token <- get_spotify_access_token()

playlist <- get_playlist_audio_features(username = "f8i8ir84uu26mppc2s5s1o4p3",
                                        playlist_uris = "2Ljg7QjvftQ7qNbGiM2Qzd",
                                        authorization = token)

playlist_features <- playlist %>%
  select(
    track.name,
    track.artists,
    track.album.release_date,
    danceability:tempo,
    time_signature,
    track.duration_ms,
    track.popularity,
    track.uri) %>%
  mutate(track.artists = map(track.artists, "name"),
         track.artists = map_chr(track.artists, paste, collapse = ";"),
         track_year = str_split(track.album.release_date, "-") %>%
           map_chr(1) %>%
           as.integer()) %>%
  select(-track.album.release_date) %>%
  janitor::clean_names()

write_csv(playlist_features, "data/06/spotify_playlist.csv")
