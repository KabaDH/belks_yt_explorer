class SearchChannel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String description;

  SearchChannel({
    required this.id,
    required this.title,
    required this.profilePictureUrl,
    required this.description,
  });

  factory SearchChannel.fromMap(Map<String, dynamic> map) {
    return SearchChannel(
      id: map['channelId'],
      title: map['title'],
      profilePictureUrl: map['thumbnails']['default']['url'],
      description: map['description'] ?? 'hidden',
    );
  }
}
