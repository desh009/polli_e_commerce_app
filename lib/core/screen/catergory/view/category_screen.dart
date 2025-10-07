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

class CategoryScreen extends StatefulWidget {
  final String? initialSelectedOption;
  final String? initialSelectedCategory;

  const CategoryScreen({
    super.key,
    this.initialSelectedCategory,
    this.initialSelectedOption,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Category1Controller categoryController = Get.put(Category1Controller());
  final CartController cartController = Get.put(CartController());

  bool showSortPanel = false;
  bool showFilterPanel = false;
  String selectedSort = "Price Low to High";

  @override
  void initState() {
    super.initState();

    if (widget.initialSelectedCategory != null ||
        widget.initialSelectedOption != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        categoryController.updateCategory(
          widget.initialSelectedCategory ?? '',
          widget.initialSelectedOption,
        );
      });
    }
  }

  /// Sorting function
  List<Map<String, dynamic>> applySort(List<Map<String, dynamic>> products) {
    switch (selectedSort) {
      case "Newest First":
        return products.reversed.toList();
      case "Name A to Z":
        products.sort((a, b) => a['name'].compareTo(b['name']));
        return products;
      case "Name Z to A":
        products.sort((a, b) => b['name'].compareTo(a['name']));
        return products;
      case "Price High to Low":
        products.sort(
          (a, b) => (b['price'] as num).compareTo(a['price'] as num),
        );
        return products;
      case "Price Low to High":
        products.sort(
          (a, b) => (a['price'] as num).compareTo(b['price'] as num),
        );
        return products;
      default:
        return products;
    }
    
  }

  /// Dummy products per category
  List<Map<String, dynamic>> getProductsForCategory(String? category) {
    switch (category) {
      case 'গুড়':
        return [
          {
            "name": "ঘোলা গুড়",
            "price": 120,
            "image": "assets/images/8521_FLEUR_DE_TOFEEWEB.jpg",
            "description":
                "ঘোলা গুড় প্রাকৃতিকভাবে তৈরি, স্বাস্থ্যসম্মত এবং মিষ্টি স্বাদের।",
          },
          {
            "name": "বিজ গুড়",
            "price": 150,
            "image": "assets/images/black-urad-laddu-recipe7-min.jpg",
            "description": "বিজ গুড় পুষ্টিকর এবং রুচিতে সুস্বাদু।",
          },
          {
            "name": "নারকেল গুড়",
            "price": 200,
            "image": "assets/images/vegan-skillet-cornbread-480x480.jpg",
            "description":
                "প্রাকৃতিক নারকেল দিয়ে তৈরি, মিষ্টি এবং স্বাস্থ্যকর।",
          },
          {
            "name": "দানাদার গুড়",
            "price": 180,
            "image": "assets/images/_41_frd_1731470695.jpg",
            "description": "দানা যুক্ত গুড়, খেতে মজাদার এবং শক্তিশালী।",
          },
          {
            "name": "চকলেট গুড়",
            "price": 220,
            "image": "assets/images/Banoffee-Choc.jpg",
            "description":
                "চকলেটের স্বাদ মিলিয়ে তৈরি, মিষ্টি প্রেমিকদের জন্য।",
          },
          {
            "name": "পাটালি গুড়",
            "price": 250,
            "image": "assets/images/patali-gur-web.png",
            "description":
                "বিশেষ প্রাকৃতিক পাটালি গুড়, দেহে শক্তি বৃদ্ধি করে।",
          },
        ];

      case 'তেল':
        return [
          {
            "name": "নারকেল তেল",
            "price": 350,
            "image":
                "assets/images/1731220762-f64714028e196b87c87dbde76bcdeb59.jpg",
            "description": "শুদ্ধ নারকেল তেল, ত্বক ও চুলের জন্য উপকারী।",
          },
          {
            "name": "সরিষা তেল",
            "price": 300,
            "image": "assets/images/80.jpg",
            "description":
                "প্রাকৃতিক সরিষা তেল, রান্নায় স্বাদ ও পুষ্টি বৃদ্ধি করে।",
          },
        ];

      case 'মসলা':
        return [
          {
            "name": "মরিচ",
            "price": 50,
            "image": "assets/images/green-hot-chili-pepper-on-white-photo.jpg",
            "description": "তাজা মরিচ, রান্নায় ঝাল স্বাদ দেয়।",
          },
          {
            "name": "হলুদ",
            "price": 40,
            "image":
                "assets/images/png-clipart-turmeric-curcumin-ras-el-hanout-home-remedy-cancer-turmeric-superfood-therapy-thumbnail.png",
            "description":
                "প্রাকৃতিক হলুদ গুঁড়া, স্বাস্থ্যকর এবং রঙিন রান্নার জন্য।",
          },
          {
            "name": "জিরা",
            "price": 60,
            "image":
                "assets/images/pngtree-zira-or-cumin-png-image_13177631.png",
            "description": "জিরা গুঁড়া, খাবারে সুগন্ধ এবং স্বাদ যোগ করে।",
          },
          {
            "name": "ধনিয়া",
            "price": 55,
            "image": "assets/images/coriander-powder-11555924245y9eah152r0.png",
            "description": "ধনিয়া গুঁড়া, স্বাদে মসৃণ এবং রান্নায় জরুরি।",
          },
          {
            "name": "গরম মশলা",
            "price": 80,
            "image":
                "assets/images/986-9865897_herbs-and-spices-clipart-transparent-khada-garam-masala.png",
            "description":
                "মশলাদার গরম মশলা, রান্নায় স্বাদ ও ঘ্রাণ বৃদ্ধি করে।",
          },
        ];

      case 'Special Item':
        return [
          {
            "name": "খোলিসা মধু",
            "price": 120,
            "image": "assets/images/sorisha-modhu.png",
            "description": "বিশেষ খোলিসা মধু, প্রাকৃতিক এবং সুস্বাদু।",
          },
          {
            "name": "কুমড়ো বরি",
            "price": 80,
            "image":
                "assets/images/1cc35ba482-q8iq1pim5akvhcaq4dr2s6sw0f53373d4uuep4udjc.jpg",
            "description": "তাজা কুমড়ো বরি, স্বাস্থ্যকর ও মজাদার।",
          },
          {
            "name": "ঘি",
            "price": 150,
            "image":
                "assets/images/pure-tup-or-desi-ghee-also-known-as-clarified-liquid-butter-free-photo.jpg",
            "description": "শুদ্ধ দেশি ঘি, রান্নায় স্বাদ বৃদ্ধি করে।",
          },
          {
            "name": "চালের গুড়া",
            "price": 60,
            "image":
                "assets/images/free-from-impurities-food-grade-100-pure-whole-wheat-flour-for-making-chapati-974.jpg.jpg",
            "description":
                "শুদ্ধ চালের গুড়া, স্বাস্থ্যসম্মত এবং রান্নায় ব্যবহারযোগ্য।",
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
      "Name A to Z",
      "Name Z to A",
      "Price High to Low",
      "Price Low to High",
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
          Navigator.pop(context);
          categoryController.updateCategory(category, option);
          setState(() {
            showSortPanel = false;
            showFilterPanel = false;
          });
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Sort & Filter Row
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                      onPressed: () => setState(() {
                        showSortPanel = true;
                        showFilterPanel = false;
                      }),
                      icon: const Icon(Icons.sort, color: Colors.black87),
                      label: const Text("Sort"),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() {
                        showFilterPanel = true;
                        showSortPanel = false;
                      }),
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black87,
                      ),
                      label: const Text("Filter"),
                    ),
                  ],
                ),
              ),

              // Products Grid
              Expanded(
                child: Obx(() {
                  final currentCategory =
                      categoryController.currentCategory.value;
                  final products = getProductsForCategory(currentCategory);
                  final sortedProducts = applySort(List.from(products));

                  if (currentCategory.isEmpty)
                    return const Center(
                      child: Text(
                        'কোনো ক্যাটেগরি নির্বাচিত হয়নি',
                        style: TextStyle(fontSize: 18),
                      ),
                    );

                  if (products.isEmpty)
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
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: sortedProducts.length,
                    itemBuilder: (context, index) {
                      final product = sortedProducts[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          ),
                        ),
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
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              ),
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
                                        fixedSize: const Size(120, 36),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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

                                        if (authController.isLoggedIn.value) {
                                          cartController.addToCart(item);
                                          Get.to(() => CartScreen(product: {}));
                                        } else {
                                          authController.pendingAction = () {
                                            cartController.addToCart(item);
                                            Get.to(
                                              () => CartScreen(product: {}),
                                            );
                                          };
                                          Get.snackbar(
                                            "Login Required",
                                            "Please log in to add items to cart.",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Add to Cart",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
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

          // Sort Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: showSortPanel ? 0 : -400,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Sort By",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => showSortPanel = false),
                      ),
                    ],
                  ),
                  ...sortOptions.map(
                    (option) => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedSort,
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                          showSortPanel = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: showFilterPanel ? 0 : -400,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => showFilterPanel = false),
                      ),
                    ],
                  ),
                  Expanded(child: FilterBottomSheet()), // আপনার filter widget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}