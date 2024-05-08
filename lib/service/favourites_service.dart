import 'package:book_now/model/enumerations/business_types.dart';
import 'package:book_now/model/favourites.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritesService {
  static Future<bool> checkIsFavourite(String businessName, BusinessTypes businessType) async {
    bool isAlreadyFavorite = false;
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    Favourites? favourites = await Favourites.findByUserEmail(currentUserEmail!);

    if (favourites != null) {
      if (businessType == BusinessTypes.hotel) {
        for (String favourite in favourites.hotelsFavourites) {
          if (favourite == businessName) {
            isAlreadyFavorite = true;
          }
        }
      } else {
        for (String favourite in favourites.businessesFavourites) {
          if (favourite == businessName) {
            isAlreadyFavorite = true;
          }
        }
      }
    }
    return isAlreadyFavorite; //false ako ne e vekje favorit, true ako e vekje favorit
  }
}