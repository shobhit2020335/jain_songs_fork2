class SongSuggestions {
  String aaa;
  String name;
  String email;
  String songName;
  String lyrics;
  String otherDetails;
  Map<String, String> songSuggestionMap = Map<String, String>();

  SongSuggestions(
      this.name, this.email, this.songName, this.lyrics, this.otherDetails) {
    this.aaa = "incomplete";
    songSuggestionMap = {
      'aaa': this.aaa,
      'email': this.email,
      'lyrics': this.lyrics,
      'name': this.name,
      'otherDetails': this.otherDetails,
      'songName': this.songName,
    };
  }
}
