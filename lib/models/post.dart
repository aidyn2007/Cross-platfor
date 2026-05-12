class Post {
  String id;
  String profileImageUrl;
  String comment;
  String timestamp;

  Post(
      this.id,
      this.profileImageUrl,
      this.comment,
      this.timestamp,
      );

}

List<Post> posts = [
  Post('1', 'assets/profile_pics/person_cesare.jpeg',
      'I am starting to read a new book about a detective.', '10'),
  Post('2', 'assets/profile_pics/person_stef.jpeg',
      'I am going to read literature for the first time.', '80'),
  Post('3', 'assets/profile_pics/person_crispy.png',
      'I found one interesting book!', '20'),
  Post('4', 'assets/profile_pics/person_joe.jpeg',
      'I will start reading a new book soon.', '30'),
  Post(
      '5',
      'assets/profile_pics/person_katz.jpeg',
      '''I'm starting to get into reading.''',
      '40'),
  Post(
      '6',
      'assets/profile_pics/person_kevin.jpeg',
      '''I found a book that suited me.''',
      '50'),
  Post(
      '7',
      'assets/profile_pics/person_sandra.jpeg',
      '''Can you recommend me some books for the evening?''',
      '50'),
  Post('8', 'assets/profile_pics/person_manda.png',
      'Why don not people today read books? They are pure pleasure!', '60'),
  Post('9', 'assets/profile_pics/person_ray.jpeg',
      'Hot off the press, cooking up more books this year!', '70'),
  Post('10', 'assets/profile_pics/person_tiffani.jpeg',
      'Are all the books in the world really here?!', '90'),
];






