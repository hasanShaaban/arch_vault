/// Mock preview image URLs used until the backend serves real thumbnails.
/// Keys match model ids across Home / Browse / Detail / Profile / Collections.
class MockPreviewImages {
  MockPreviewImages._();

  static const String fallback =
      'https://images.unsplash.com/photo-1487958449943-2429e8be8624?auto=format&fit=crop&w=800&q=80';

  static const Map<String, String> byId = {
    '1':
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80',
    '2':
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80',
    '3':
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
    '4':
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
    '5':
        'https://images.unsplash.com/photo-1449844908441-8829872d2607?auto=format&fit=crop&w=800&q=80',
    '6':
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    '7':
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=800&q=80',
    '8':
        'https://images.unsplash.com/photo-1577495508048-b659178b64eb?auto=format&fit=crop&w=800&q=80',
    '9':
        'https://images.unsplash.com/photo-1511818966892-d7d671eedd7b?auto=format&fit=crop&w=800&q=80',
    '10':
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=800&q=80',
    '11':
        'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=800&q=80',
  };

  static String forId(String id) => byId[id] ?? fallback;
}
