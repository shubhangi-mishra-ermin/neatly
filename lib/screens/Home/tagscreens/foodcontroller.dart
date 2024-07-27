import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var foodTags = <String>[].obs;
  var foodItemsMap = <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoodTags();
  }

  Future<void> fetchFoodTags() async {
    try {
      final foodCollection = _firestore.collection('Food');
      final querySnapshot = await foodCollection.get();

      for (var doc in querySnapshot.docs) {
        final tagNames = [
          'Beef',
          'Chicken',
          'Fish',
          'Lamb',
          'Mutton',
          'Shrimp'
        ];

        for (var tag in tagNames) {
          final tagCollection = foodCollection.doc(doc.id).collection(tag);
          final tagSnapshot = await tagCollection.get();

          if (tagSnapshot.docs.isNotEmpty) {
            foodTags.add(tag);
          }
        }
      }

      print("foodTags.value :: ${foodTags}");
    } catch (e) {
      print('Error fetching food tags: $e');
    }
  }

  Future<void> fetchFoodItemsList(String foodTag) async {
    try {
      final foodCollection = _firestore.collection('Food');
      final foodItems = <Map<String, dynamic>>[];

      // Retrieve the tag document
      final tagCollection =
          foodCollection.doc('kRVyJIo4IcjMDntKzpM7').collection(foodTag);
      final tagSnapshot = await tagCollection.get();

      for (var doc in tagSnapshot.docs) {
        final subCollections =
            await _listSubCollections(doc.reference, foodTag);

        for (var subCollection in subCollections) {
          final itemsSnapshot = await subCollection.get();
          print("itemsSnapshot :: $itemsSnapshot");
          for (var itemDoc in itemsSnapshot.docs) {
            var itemData = itemDoc.data() as Map<String, dynamic>;
            itemData['id'] = itemDoc.id;
            foodItems.add(itemData);
          }
        }
      }

      foodItemsMap[foodTag] = foodItems;
      print("foodItemsMap.value :: ${foodItemsMap}");
    } catch (e) {
      print('Error fetching food items: $e');
    }
  }

  Future<List<CollectionReference>> _listSubCollections(
      DocumentReference docRef, String foodTag) async {
    final subCollections = <CollectionReference>[];

    try {
      List<String> subCollectionNames;

      // Define sub-collection names based on the food tag
      switch (foodTag.toLowerCase()) {
        case 'beef':
          subCollectionNames = [
            'beef-curry cut',
            'beef-legs',
            'beef-ribs',
            'beef-steakcut'
          ];
          break;
        case 'chicken':
          subCollectionNames = [
            'chicken-breast',
            'chicken-curry cut',
            'chicken-drums',
            'chicken-legs',
            'chicken-whole'
          ];
          break;
        case 'fish':
          subCollectionNames = ['fish-type A', 'fish-type B', 'fish-type C'];
          break;
        case 'lamb':
          subCollectionNames = ['lamb-curry cut', 'lamb-tenders'];
          break;
        case 'mutton':
          subCollectionNames = ['mutton-legs', 'mutton-ribs'];
          break;
        case 'shrimp':
          subCollectionNames = ['shrimp-type A', 'shrimp-type B'];
          break;
        default:
          subCollectionNames = [];
      }

      for (var subCollectionName in subCollectionNames) {
        final subCollectionRef = docRef.collection(subCollectionName);
        subCollections.add(subCollectionRef);
      }
    } catch (e) {
      print('Error listing sub-collections: $e');
    }

    return subCollections;
  }
}
