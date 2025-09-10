import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/view/add_to_cart_scree.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/controller/categpory_contrpoller.dart';
import 'package:polli_e_commerce_app/core/screen/filter_bottom_sheet_screen.dart';
import 'package:polli_e_commerce_app/core/screen/product_screen.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';

class DrawerControllerX extends GetxController {
  var selectedItem = "".obs;
}

class CategoryScreen extends StatefulWidget {
  final String? initialSelectedCategory;

  const CategoryScreen({
    super.key,
    this.initialSelectedCategory,
    String? initialSelectedOption,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final int pendingOrders = 3;

  // Controllers
  final CategoryController categoryController = Get.put(CategoryController());
  late CartController cartController;

  bool showSortPanel = false;

  String selectedSort = "Price Low to High";

  @override
  void initState() {
    super.initState();
    cartController = Get.put(CartController());

    // Set initial category if passed
    if (widget.initialSelectedCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        categoryController.updateCategory(
          widget.initialSelectedCategory!,
          null,
        );
      });
    }
  }

  void applySort(List<Map<String, dynamic>> products) {
    switch (selectedSort) {
      case "Newest First":
        products = products.reversed.toList();
        break;
      case "Oldest First":
        break;
      case "Name A to Z":
        products.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case "Name Z to A":
        products.sort((a, b) => b['name'].compareTo(a['name']));
        break;
      case "Price High to Low":
        products.sort(
          (a, b) => (b['price'] as num).compareTo(a['price'] as num),
        );
        break;
      case "Price Low to High":
        products.sort(
          (a, b) => (a['price'] as num).compareTo(b['price'] as num),
        );
        break;
    }
  }

  List<Map<String, dynamic>> getProductsForCategory(String? category) {
    switch (category) {
      case 'গুড়':
        return [
          {
            "name": "ঘোলা গুড়",
            "price": 120,
            "image": "assets/images/8521_FLEUR_DE_TOFEEWEB.jpg",
          },
          {
            "name": "বিজ গুড়",
            "price": 150,
            "image": "assets/images/black-urad-laddu-recipe7-min.jpg",
          },
          {
            "name": "নারকেল গুড়",
            "price": 200,
            "image": "assets/images/vegan-skillet-cornbread-480x480.jpg",
          },
          {
            "name": "দানাদার গুড়",
            "price": 180,
            "image": "assets/images/_41_frd_1731470695.jpg",
          },
          {
            "name": "চকলেট গুড়",
            "price": 220,
            "image": "assets/images/Banoffee-Choc.jpg",
          },
          {
            "name": "পাটালি গুড়",
            "price": 250,
            "image": "assets/images/patali-gur-web.png",
          },
        ];
      case 'তেল':
        return [
          {
            "name": "নারকেল তেল",
            "price": 350,
            "image":
                "assets/images/1731220762-f64714028e196b87c87dbde76bcdeb59.jpg",
          },
          {"name": "সরিষা তেল", "price": 300, "image": "assets/images/80.jpg"},
        ];
      case 'মসলা':
        return [
          {
            "name": "মরিচ",
            "price": 50,
            "image": "assets/images/green-hot-chili-pepper-on-white-photo.jpg",
          },
          {
            "name": "হলুদ",
            "price": 40,
            "image":
                "assets/images/png-clipart-turmeric-curcumin-ras-el-hanout-home-remedy-cancer-turmeric-superfood-therapy-thumbnail.png",
          },
          {
            "name": "জিরা",
            "price": 60,
            "image":
                "assets/images/pngtree-zira-or-cumin-png-image_13177631.png",
          },
          {
            "name": "ধনিয়া",
            "price": 55,
            "image": "assets/images/coriander-powder-11555924245y9eah152r0.png",
          },
          {
            "name": "গরম মশলা",
            "price": 80,
            "image":
                "assets/images/986-9865897_herbs-and-spices-clipart-transparent-khada-garam-masala.png",
          },
        ];
      case 'Special Item':
        return [
          {
            "name": "খোলিসা মধু",
            "price": 120,
            "image": "assets/images/sorisha-modhu.png",
          },
          {
            "name": "কুমড়ো বরি",
            "price": 80,
            "image":
                "assets/images/1cc35ba482-q8iq1pim5akvhcaq4dr2s6sw0f53373d4uuep4udjc.jpg",
          },
          {
            "name": "ঘি",
            "price": 150,
            "image":
                "assets/images/pure-tup-or-desi-ghee-also-known-as-clarified-liquid-butter-free-photo.jpg",
          },
          {
            "name": "চালের গুড়া",
            "price": 60,
            "image":
                "assets/images/free-from-impurities-food-grade-100-pure-whole-wheat-flour-for-making-chapati-974.jpg.jpg",
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      "Newest First",
      "Oldest First",
      "Name A to Z",
      "Name Z to A",
      "Price High to Low",
      "Price Low to High",
      "Express Delivery",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Obx(
          () => Text(
            categoryController.currentCategory.value.isEmpty
                ? 'ক্যাটেগরি'
                : categoryController.currentCategory.value,
          ),
        ),
      ),
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          Navigator.pop(context); // drawer close

          // Force update করো
          categoryController.updateCategory(category, option);

          setState(() {
            showSortPanel = false;
          });
        },
      ),

      body: Column(
        children: [
          // Sort & Filter Row
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      showSortPanel = !showSortPanel;
                    });
                  },
                  icon: const Icon(Icons.sort, color: Colors.black87),
                  label: const Text("Sort"),
                ),
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => FilterBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.black87),
                  label: const Text("Filter"),
                ),
              ],
            ),
          ),

          // Sort Panel
          if (showSortPanel)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sort by",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...sortOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedSort,
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        showSortPanel = false;
                      });
                    },
                    child: const Text("Apply"),
                  ),
                ],
              ),
            ),

          // Products Grid
          Expanded(
            child: Obx(() {
              final currentCategory = categoryController.currentCategory.value;
              print(
                "Current Category in build: $currentCategory",
              ); // Debug করার জন্য

              if (currentCategory.isEmpty) {
                return const Center(
                  child: Text(
                    'কোনো ক্যাটেগরি নির্বাচিত হয়নি',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              final products = getProductsForCategory(currentCategory);

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'এই ক্যাটেগরিতে কোনো পণ্য নেই',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              // Sort apply করো
              List<Map<String, dynamic>> sortedProducts = List.from(products);
              applySort(sortedProducts);

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: sortedProducts.length,
                itemBuilder: (context, index) {
                  final product = sortedProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  product['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '৳${product['price']}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    fixedSize: const Size(140, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    final authController =
                                        Get.find<AuthController>();
                                    final item = CartItem(
                                      id: index,
                                      name: product['name'],
                                      category: currentCategory,
                                      price: (product['price'] as num)
                                          .toDouble(),
                                      quantity: 1,
                                      imagePath: product['image'],
                                    );

                                    if (authController.isLoggedIn.value){
                                    cartController.addToCart(item);
                                    Get.to(() => CartScreen(product: {}));
                                  
                                  } else {
                                      // Login page এ যাও
                                      authController.pendingAction = () {
                                        cartController.addToCart(item);
                                        Get.to(() => CartScreen(product: {}));
                                      };
                                      Get.snackbar(
                                        "Login Required",
                                        "Please log in to add items to cart.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                      );
                                      // এখানে তোমার login page এর navigation code দাও
                                    }
                                  },
                                  child: const Text("Add to Cart"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
