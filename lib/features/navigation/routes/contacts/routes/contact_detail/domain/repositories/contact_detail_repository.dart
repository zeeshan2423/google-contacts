abstract class ContactDetailRepository {
  Future<void> deleteContact(String id);

  Future<void> toggleFavorite(String id);
}
