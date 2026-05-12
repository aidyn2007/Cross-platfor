class Item {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Restaurant {
  String id;
  String name;
  String address;
  String attributes;
  String imageUrl;
  String imageCredits;
  double distance;
  double rating;
  List<Item> items;

  Restaurant(
      this.id,
      this.name,
      this.address,
      this.attributes,
      this.imageUrl,
      this.imageCredits,
      this.distance,
      this.rating,
      this.items,
      );

  String getRatingAndDistance() {
    return '''Rating: ${rating.toStringAsFixed(1)} ★ | Distance: ${distance.toStringAsFixed(1)} miles''';
  }
}

List<Restaurant> restaurants = [
  Restaurant(
    '0',
    'Action & Adventure',
    'fast-paced stories centered on exciting, high-stakes journeys, physical challenges, and danger. ',
    '',
    'assets/restaurants/TheBluePrawn.webp',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=962&q=80',
    2.1,
    4.5,
    [
      Item(
        name: 'Twelve Months',
        description:
        '''Harry Dresden, Chicago’s only professional wizard, has always managed to save the day—but, in this powerful entry in the #1 New York Times bestselling Dresden Files, can he save himself?''',
        price: 14.99,
        imageUrl:
        'https://image.ebooks.com/cover/346345628.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'The Way of Kings',
        description:
        '''From #1 New York Times bestselling author Brandon Sanderson, The Way of Kings, Book One of the Stormlight Archive, begins an incredible new saga of epic proportion.''',
        price: 16.99,
        imageUrl:
        'https://image.ebooks.com/cover/612873.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'A Game of Thrones',
        description:
        '''Here is the first book in the landmark series that has redefined imaginative fiction and become a modern masterpiece.''',
        price: 19.99,
        imageUrl:
        'https://image.ebooks.com/cover/357428.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'Mistborn Trilogy',
        description:
        '''From #1 New York Times bestselling author Brandon Sanderson, the Mistborn trilogy is a heist story of political intrigue and magical, martial-arts action.''',
        price: 21.99,
        imageUrl:
        'https://image.ebooks.com/cover/630871.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'A Knight of the Seven Kingdoms',
        description:
        '''Taking place nearly a century before the events of A Game of Thrones, A Knight of the Seven Kingdoms compiles the three official prequel novellas to George R. R. Martin's ongoing masterwork, A Song of Ice and Fire.''',
        price: 17.99,
        imageUrl:
        'https://image.ebooks.com/cover/1918533.jpg?width=420&height=630&quality=85',
      ),
    ],
  ),
  Restaurant(
    '1',
    'Fantasy',
    '603 Cedar St, Chicago, AZ 92294',
    '',
    'assets/restaurants/MamaRosasPizza.webp',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=962&q=80',
    0.7,
    4.7,
    [
      Item(
        name: 'Empire of the Dawn',
        description:
        '''From Jay Kristoff,New York Times bestselling author of the Empire of the Vampire and Empire of the Damned.''',
        price: 12.99,
        imageUrl:
        'https://image.ebooks.com/cover/345916440.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'The Goblin Emperor',
        description:
        '''A lush tale of deadly court intrigue and a modern classic of fantasy by Locus award winner and Hugo, Nebula, and World Fantasy Award finalist Katherine Addison.''',
        price: 14.99,
        imageUrl:
        'https://image.ebooks.com/cover/1449933.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'The City & The City',
        description:
        '''NAMED ONE OF THE BEST BOOKS OF THE YEAR BY THE LOS ANGELES TIMES, THE SEATTLE TIMES, AND PUBLISHERS WEEKLY.''',
        price: 13.99,
        imageUrl:
        'https://image.ebooks.com/cover/357387.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'Wheel of the Infinite',
        description:
        '''A traitor and a swordsman join forces to save the world from being rewritten into devastation.''',
        price: 15.99,
        imageUrl:
        'https://image.ebooks.com/cover/211174555.jpg?width=420&height=630&quality=85',
      ),
      Item(
        name: 'The Princess Bride',
        description:
        '''The publisher of this book has not provided a description. Please check back later.''',
        price: 17.99,
        imageUrl:
        'https://image.ebooks.com/cover/210451748.jpg?width=420&height=630&quality=85',
      ),
      Item(
          name: 'Empire of the Vampire',
          description:
          '''THE INSTANT NEW YORK TIMES, USA TODAY, AND WALL STREET JOURNAL BESTSELLER''',
          price: 7.99,
          imageUrl:
          'https://image.ebooks.com/cover/210187832.jpg?width=420&height=630&quality=85'),
    ],
  ),
  Restaurant(
    '2',
    'Romance',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/BistroDeParis.jpg',
    'https://images.unsplash.com/photo-1608855238293-a8853e7f7c98?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
    3.3,
    4.8,
    [
      Item(
          name: 'Onyx Storm',
          description:
          '''AN INSTANT #1 NEW YORK TIMES BESTSELLER.''',
          price: 26.99,
          imageUrl:
          'https://image.ebooks.com/cover/211254343.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The Spellshop',
          description:
          '''AN INSTANT NEW YORK TIMES, USA TODAY AND INDIE BESTSELLER!''',
          price: 29.99,
          imageUrl:
          'https://image.ebooks.com/cover/211108749.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'My Funny Demon Valentine',
          description:
          '''Instant New York Times Bestseller''',
          price: 28.99,
          imageUrl:
          'https://image.ebooks.com/cover/211332510.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Quicksilver',
          description:
          '''This #1 New York Times bestseller is a highly addicting enemies-to-lovers Romantasy.''',
          price: 22.99,
          imageUrl:
          'https://image.ebooks.com/cover/211440951.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'King of Battle and Blood',
          description:
          '''An instant USA Today bestseller! From fan-favorite Scarlett St. Clair, the bestselling author of the Hades & Persephone series, comes a new fantasy filled with danger, darkness, and insatiable romance.''',
          price: 9.99,
          imageUrl:
          'https://image.ebooks.com/cover/210409887.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The Enchanted Greenhouse',
          description:
          '''New York Times bestselling author Sarah Beth Durst invites you to her new standalone novel set in the world of The Spellshop!''',
          price: 49.99,
          imageUrl:
          'https://image.ebooks.com/cover/211450445.jpg?width=420&height=630&quality=85'),
    ],
  ),
  Restaurant(
    '3',
    'Historical Fiction',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/GreenZenphony.jpg',
    'https://images.unsplash.com/photo-1540914124281-342587941389?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1548&q=80',
    1.5,
    4.4,
    [
      Item(
          name: 'Goliaths Curse',
          description:
          '''NAMED A BEST BOOK OF THE YEAR BY THE CONVERSATION AND KIRKUS.''',
          price: 14.99,
          imageUrl:
          'https://image.ebooks.com/cover/211462593.jpg?width=420&height=630&quality=85'),
      Item(
          name: '1929',
          description:
          '''#1 NEW YORK TIMES BESTSELLER.''',
          price: 12.99,
          imageUrl:
          'https://image.ebooks.com/cover/345994541.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The American Revolution',
          description:
          '''From the award-winning historian and filmmakers of The Civil War, Baseball, Jazz, The Roosevelts, and others.''',
          price: 10.99,
          imageUrl:
          'https://image.ebooks.com/cover/345993765.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Inventing the Renaissance',
          description:
          '''An irreverent new take on the Renaissance, which reveals it as anything but Europe’s golden age.''',
          price: 6.99,
          imageUrl:
          'https://image.ebooks.com/cover/345991526.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The Trillion Dollar War Machine',
          description:
          '''A hard-hitting investigation into how the Pentagon’s runaway spending embroils America in foreign wars, squanders its wealth, and enriches a privileged elite.''',
          price: 7.99,
          imageUrl:
          'https://image.ebooks.com/cover/345992151.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Chaos',
          description:
          '''NEW YORK TIMES BESTSELLER | NOW A NETFLIX DOCUMENTARY.''',
          price: 4.99,
          imageUrl:
          'https://image.ebooks.com/cover/209528141.jpg?width=420&height=630&quality=85'),
    ],
  ),
  Restaurant(
    '4',
    'Biographies & History',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/TandooriFlame.jpg',
    'https://images.unsplash.com/photo-1617692855027-33b14f061079?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
    2.8,
    4.2,
    [
      Item(
          name: 'Picking Cotton',
          description:
          '''The New York Times best selling true story of an unlikely friendship forged between a woman and the man she incorrectly identified as her rapist and sent to prison for 11 years.''',
          price: 15.99,
          imageUrl:
          'https://image.ebooks.com/cover/632232.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Mr Wilman’s Motoring Adventure',
          description:
          '''Lift the bonnet on 20 years of magic and mayhem on Top Gear and The Grand Tour - from the mysterious man behind the camera.''',
          price: 14.99,
          imageUrl:
          'https://image.ebooks.com/cover/345993250.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'They Said This Would Be Fun',
          description:
          '''A powerful, moving memoir about what it's like to be a student of colour on a predominantly white campus.''',
          price: 12.99,
          imageUrl:
          'https://image.ebooks.com/cover/209769997.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Last Night I Dreamed of Peace',
          description:
          '''At the age of twenty-four, Dang Thuy Tram volunteered to serve as a doctor in a National Liberation Front (Viet Cong) battlefield hospital in the Quang Ngai Province.''',
          price: 11.99,
          imageUrl:
          'https://image.ebooks.com/cover/291653.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'A Hymn to Life',
          description:
          '''THE INSTANT NEW YORK TIMES BESTSELLER.''',
          price: 18.99,
          imageUrl:
          'https://image.ebooks.com/cover/346629008.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Four Hundred Souls',
          description:
          '''#1 NEW YORK TIMES BESTSELLER.''',
          price: 14.99,
          imageUrl:
          'https://image.ebooks.com/cover/210098531.jpg?width=420&height=630&quality=85'),
    ],
  ),
  Restaurant(
    '5',
    'Children',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/ElToroLoco.jpg',
    'https://images.unsplash.com/photo-1615870216519-2f9fa575fa5c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80',
    0.9,
    4.3,
    [
      Item(
          name: 'Off We Go Around Australia',
          description:
          '''From the tip of the Top End to way out west, Australia is packed with magical things to see and do.''',
          price: 13.99,
          imageUrl:
          'https://image.ebooks.com/cover/210247650.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Worse Things',
          description:
          '''Worse Things is a story about connections, the ways they are made, and what happens when they are lost or illusive, from the award-winning author of Pearl Verses the World and Toppling.''',
          price: 14.99,
          imageUrl:
          'https://image.ebooks.com/cover/209974775.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Storm Boy',
          description:
          '''Storm boy and his father live alone in a humpy among the sandhills between the Southern Ocean and the Coorong - a lonely, narrow waterway that runs parallel to a long stretch of the South Australian coast. Among the teeming birdlife of the Coorong.''',
          price: 12.99,
          imageUrl:
          'https://image.ebooks.com/cover/530084.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The Hybrid Prince',
          description:
          'The #1 New York Times bestselling series is back with a brand new arc!',
          price: 6.99,
          imageUrl:
          'https://image.ebooks.com/cover/346453265.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The City of Ember',
          description:
          '''A modern-day classic. This highly acclaimed adventure series about two friends desperate to save their doomed city has captivated kids and teachers alike for almost fifteen years and has sold over 3.5 MILLION copies!''',
          price: 8.99,
          imageUrl:
          'https://image.ebooks.com/cover/192394.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Hero: A Wings of Fire Story',
          description:
          '''Wings of Fire returns with this brand new short story featuring a fan favorite character, plus a sneak-peek at Wings of Fire #16: The Hybrid Prince!''',
          price: 7.99,
          imageUrl:
          'https://image.ebooks.com/cover/347264107.jpg?width=420&height=630&quality=85'),
    ],
  ),
  Restaurant(
    '6',
    'Mystery & Thriller',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/OldKyotoSushi.jpg',
    'https://images.unsplash.com/photo-1564489563601-c53cfc451e93?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80',
    4.2,
    4.6,
    [
      Item(
          name: 'The Hard Line',
          description:
          '''The Gray Man, the world’s deadliest assassin and apex predator, discovers he’s really the prey in the most shocking entry of this #1 New York Times bestselling series.''',
          price: 13.99,
          imageUrl:
          'https://image.ebooks.com/cover/346543734.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Dark Matter',
          description:
          '''NEW YORK TIMES BESTSELLER • OVER ONE MILLION COPIES SOLD!''',
          price: 14.99,
          imageUrl:
          'https://image.ebooks.com/cover/2414261.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The Secret of Secrets',
          description:
          '''INSTANT #1 NEW YORK TIMES BESTSELLER • THE NEW ROBERT LANGDON THRILLER FROM THE ICONIC AUTHOR OF THE DA VINCI CODE''',
          price: 12.99,
          imageUrl:
          'https://image.ebooks.com/cover/345993422.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'Cold Zero',
          description:
          '''From #1 New York Times bestselling author Brad Thor and USA TODAY bestselling author Ward Larsen, comes a heart-pounding thriller of survival, espionage, and global brinkmanship, where the frozen Arctic becomes the deadliest battlefield on Earth.''',
          price: 6.99,
          imageUrl:
          'https://image.ebooks.com/cover/346558452.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'My Husbands Wife',
          description: 'Discover the brand new #1 bestselling book everyone is talking about from the author of His & Hers, now a #1 Netflix show!',
          price: 8.99,
          imageUrl:
          'https://image.ebooks.com/cover/346396444.jpg?width=420&height=630&quality=85'),
      Item(
          name: 'The Widow',
          description:
          '''#1 NEW YORK TIMES BESTSELLER • John Grisham is the acclaimed master of the legal thriller. Now, he’s back with his first-ever whodunit, even more suspenseful than his courtroom dramas, as a small-time lawyer accused of murder races to find the real killer to clear his name.''',
          price: 7.99,
          imageUrl:
          'https://image.ebooks.com/cover/346004026.jpg?width=420&height=630&quality=85'),
    ],
  ),
  Restaurant(
    '7',
    'Non-Fiction',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/TuscanOlive.jpg',
    'https://images.unsplash.com/photo-1616299915952-04c803388e5f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1524&q=80',
    3.5,
    4.7,
    [
      Item(
          name: 'Fettuccine Alfredo',
          description:
          '''Creamy pasta dish made with butter, heavy cream, and Parmesan cheese, topped with freshly chopped parsley.''',
          price: 14.99,
          imageUrl:
          'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
      Item(
          name: 'Spaghetti Carbonara',
          description:
          '''Classic Roman dish with spaghetti, eggs, Pecorino Romano, guanciale, and pepper.''',
          price: 13.99,
          imageUrl:
          'https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80'),
      Item(
          name: 'Eggplant Parmigiana',
          description:
          '''Layers of thinly sliced eggplant, marinara sauce, and mozzarella, baked to perfection.''',
          price: 15.99,
          imageUrl:
          'https://images.unsplash.com/photo-1594576182733-ad4ec76e674f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
      Item(
          name: 'Osso Buco',
          description:
          '''Slow-cooked veal shanks in a white wine and tomato sauce, served with risotto alla Milanese.''',
          price: 24.99,
          imageUrl:
          'https://images.unsplash.com/photo-1620167789167-b18dea494214?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
      Item(
          name: 'Tiramisu',
          description:
          '''Delicate layers of coffee-soaked ladyfingers and mascarpone cheese, dusted with cocoa powder.''',
          price: 8.99,
          imageUrl:
          'https://images.unsplash.com/photo-1586040140378-b5634cb4c8fc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=772&q=80'),
      Item(
          name: 'Chianti Classico',
          description:
          '''A robust red wine with flavors of dark cherry and spice, perfect for pairing with hearty Italian dishes.''',
          price: 12.99,
          imageUrl:
          'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80'),
    ],
  ),
  Restaurant(
    '8',
    'Science Fiction',
    '810 Main St, San Jose, NY 19113',
    '',
    'assets/restaurants/TheBreakfastClub.jpg',
    'https://images.unsplash.com/photo-1611601184963-9d1de9b79ff3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
    0.5,
    4.5,
    [
      Item(
          name: 'Classic Pancake Stack',
          description:
          '''Fluffy buttermilk pancakes served with butter, maple syrup, and a side of fresh berries.''',
          price: 9.99,
          imageUrl:
          'https://images.unsplash.com/photo-1565299543923-37dd37887442?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=962&q=80'),
      Item(
        name: 'Eggs Benedict',
        description:
        '''Toasted English muffins topped with ham, poached eggs, and creamy hollandaise sauce.''',
        price: 12.99,
        imageUrl:
        'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80',
      ),
      Item(
          name: 'Avocado Toast',
          description:
          '''Whole grain toast spread with ripe avocado, cherry tomatoes, radish slices, and a sprinkle of feta.''',
          price: 8.99,
          imageUrl:
          'https://images.unsplash.com/photo-1603046891726-36bfd957e0bf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80'),
      Item(
          name: 'French Toast Casserole',
          description:
          '''Sweet and savory bread pudding style French toast served with a side of crispy bacon.''',
          price: 11.99,
          imageUrl:
          'https://images.unsplash.com/photo-1510693206972-df098062cb71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1298&q=80'),
      Item(
          name: 'Cappuccino',
          description:
          '''A perfect blend of espresso, steamed milk, and a frothy top, dusted with cocoa or cinnamon.''',
          price: 3.99,
          imageUrl:
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1270&q=80'),
      Item(
          name: 'Vegan Breakfast Burrito',
          description:
          '''A hearty wrap filled with scrambled tofu, sautéed vegetables, black beans, and avocado. Served with salsa on the side.''',
          price: 10.99,
          imageUrl:
          'https://images.unsplash.com/photo-1574365361850-8e8aec561723?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80'),
    ],
  ),
];
