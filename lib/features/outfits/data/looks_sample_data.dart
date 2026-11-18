import '../models/saved_look.dart';

abstract final class LooksSampleData {
  static const looks = <SavedLook>[
    SavedLook(
      id: 'look_01',
      number: 1,
      title: 'Noir Tailoring',
      description: 'Blazer, Trouser, Poplin, Lug loafer',
      date: 'OCT 24',
      itemCount: 4,
      imagePath: 'assets/images/looks/look_01.jpg',
    ),
    SavedLook(
      id: 'look_02',
      number: 2,
      title: 'Cyber Minimalism',
      description: 'Tech Trench, Harness, Storm Pant, Boot',
      date: 'NOV 02',
      itemCount: 5,
      imagePath: 'assets/images/looks/look_02.jpg',
    ),
    SavedLook(
      id: 'look_03',
      number: 3,
      title: 'Architectural Drape',
      description: 'Asymmetric Knit, Fluid Culotte, Mule',
      date: 'NOV 14',
      itemCount: 3,
      imagePath: 'assets/images/looks/look_03.jpg',
    ),
    SavedLook(
      id: 'look_04',
      number: 4,
      title: 'Monochrome Casual',
      description: 'Heavy Boxy Tee, Raw Denim, Derby, Tote',
      date: 'DEC 01',
      itemCount: 4,
      imagePath: 'assets/images/looks/look_04.jpg',
    ),
  ];
}
