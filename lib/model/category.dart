enum Category {
  men,
  women,
  electronicsAndGadgets,
  accessories,
}

enum SubCategory {
  all,
  // Men's Subcategories
  shirts,
  tShirts,
  pants,
  kurtas,
  jackets,
  shoes,
  otherMen,

  // Women's Subcategories
  dresses,
  tops,
  jeans,
  shorts,
  skirts,
  shoesWomen,
  otherWomen,

  // Electronics & Gadgets Subcategories
  watches,
  mobilePhones,
  mobileAccessories,
  otherElectronics,

  // Accessories Subcategories
  laptops,
  mobiles,
  otherAccessories,
}

final Map<String, SubCategory> mapSubCat = {
  'all': SubCategory.all,
  'shirts': SubCategory.shirts,
  'T-Shirts': SubCategory.tShirts,
  'Pants': SubCategory.pants,
  'Kurtas': SubCategory.kurtas,
  'Jackets': SubCategory.jackets,
  'Shoes': SubCategory.shoes,
  'Other Men\'s Items': SubCategory.otherMen,
  'Dresses': SubCategory.dresses,
  'Tops': SubCategory.tops,
  'Jeans': SubCategory.jeans,
  'Shorts': SubCategory.shorts,
  'Skirts': SubCategory.skirts,
  'Women\'s Shoes': SubCategory.shoesWomen,
  'Other Women\'s Items': SubCategory.otherWomen,
  'Watches': SubCategory.watches,
  'Mobile Phones': SubCategory.mobilePhones,
  'Mobile Accessories': SubCategory.mobileAccessories,
  'Other Electronics': SubCategory.otherElectronics,
  'Laptops': SubCategory.laptops,
  'Mobiles': SubCategory.mobiles,
  'Other Accessories': SubCategory.otherAccessories,
};

// Category Extension
extension CategoryExtension on Category {
  List<SubCategory> get subCategories {
    switch (this) {
      case Category.men:
        return [
          SubCategory.shirts,
          SubCategory.tShirts,
          SubCategory.pants,
          SubCategory.kurtas,
          SubCategory.jackets,
          SubCategory.shoes,
          SubCategory.otherMen,
        ];
      case Category.women:
        return [
          SubCategory.dresses,
          SubCategory.tops,
          SubCategory.jeans,
          SubCategory.shorts,
          SubCategory.skirts,
          SubCategory.shoesWomen,
          SubCategory.otherWomen,
        ];
      case Category.electronicsAndGadgets:
        return [
          SubCategory.watches,
          SubCategory.mobilePhones,
          SubCategory.mobileAccessories,
          SubCategory.otherElectronics,
        ];
      case Category.accessories:
        return [
          SubCategory.laptops,
          SubCategory.mobiles,
          SubCategory.otherAccessories,
        ];
      default:
        return [];
    }
  }
}
