import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String? initialSelectedCategory; // initial category

  const CategoryScreen({Key? key, this.initialSelectedCategory})
    : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> categories = ['গুড়', 'তেল', 'মসলা', 'Special Item'];
  String? selectedCategory;

  final Map<String, Map<String, dynamic>> gurOptions = {
    'ঘোলা গুড়': {
      'image': 'assets/images/8521_FLEUR_DE_TOFEEWEB.jpg',
      'price': 120,
    },
    'বিজ গুড়': {
      'image': 'assets/images/black-urad-laddu-recipe7-min.jpg',
      'price': 150,
    },
    'নারকেল গুড়': {
      'image': 'assets/images/vegan-skillet-cornbread-480x480.jpg',
      'price': 200,
    },
    'দানাদার গুড়': {
      'image': 'assets/images/_41_frd_1731470695.jpg',
      'price': 180,
    },
    'চকলেট গুড়': {'image': 'assets/images/Banoffee-Choc.jpg', 'price': 220},
    'পাটালি গুড়': {'image': 'assets/images/patali-gur-web.png', 'price': 250},
  };

  final Map<String, Map<String, dynamic>> telOptionsWithImage = {
    'নারকেল তেল': {
      'image': 'assets/images/1731220762-f64714028e196b87c87dbde76bcdeb59.jpg',
      'price': 350,
    },
    'সরিষা তেল': {'image': 'assets/images/80.jpg', 'price': 300},
  };

  final Map<String, Map<String, dynamic>> moslaOptionsWithImage = {
    'মরিচ': {
      'image': 'assets/images/green-hot-chili-pepper-on-white-photo.jpg',
      'price': 50,
    },
    'হলুদ': {
      'image':
          'assets/images/png-clipart-turmeric-curcumin-ras-el-hanout-home-remedy-cancer-turmeric-superfood-therapy-thumbnail.png',
      'price': 40,
    },
    'জিরা': {
      'image': 'assets/images/pngtree-zira-or-cumin-png-image_13177631.png',
      'price': 60,
    },
    'ধনিয়া': {
      'image': 'assets/images/coriander-powder-11555924245y9eah152r0.png',
      'price': 55,
    },
    'গরম মশলা': {
      'image':
          'assets/images/986-9865897_herbs-and-spices-clipart-transparent-khada-garam-masala.png',
      'price': 80,
    },
  };

  final Map<String, Map<String, dynamic>>
  specialItemOptionsWithImageAndPrice = {
    'খোলিসা মধু': {'image': 'assets/images/sorisha-modhu.png', 'price': 120},
    'কুমড়ো বরি': {
      'image':
          'assets/images/1cc35ba482-q8iq1pim5akvhcaq4dr2s6sw0f53373d4uuep4udjc.jpg',
      'price': 80,
    },
    'ঘি': {
      'image':
          'assets/images/pure-tup-or-desi-ghee-also-known-as-clarified-liquid-butter-free-photo.jpg',
      'price': 150,
    },
    'চালের গুড়া': {
      'image':
          'assets/images/free-from-impurities-food-grade-100-pure-whole-wheat-flour-for-making-chapati-974.jpg.jpg',
      'price': 60,
    },
  };

  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialSelectedCategory; // set initial category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পল্লী স্বাদ'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Home / Shop', style: TextStyle(color: Colors.grey)),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'CATEGORIES',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              height: 3,
              width: 50,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3,
                          ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return categoryCard(categories[index]);
                      },
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return categoryCard(categories[index]);
                      },
                    );
                  }
                },
              ),
            ),
            if (selectedCategory == 'গুড়')
              showOptions(
                'গুড় এর ধরনসমূহ',
                gurOptions.cast<String, Map<String, dynamic>>(),
              ),
            if (selectedCategory == 'তেল')
              showOptions(
                'তেলের ধরনসমূহ',
                telOptionsWithImage.cast<String, Map<String, dynamic>>(),
              ),
            if (selectedCategory == 'মসলা')
              showOptions(
                'মসলার ধরনসমূহ',
                moslaOptionsWithImage.cast<String, Map<String, dynamic>>(),
              ),
            if (selectedCategory == 'Special Item')
              showOptions(
                'Special Item',
                specialItemOptionsWithImageAndPrice
                    .cast<String, Map<String, dynamic>>(),
              ),
            selectedOptionDisplay(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRICE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 3,
                    width: 50,
                    color: Colors.amber,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.greenAccent.shade100,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: minPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Min Price',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: maxPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Max Price',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Filter applied: ${minPriceController.text} - ${maxPriceController.text}',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Apply Filter'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selected Category: ${selectedCategory ?? 'None'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryCard(String title) {
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.image, size: 30, color: Colors.grey),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          setState(() {
            selectedCategory = selectedCategory == title ? null : title;
          });
        },
      ),
    );
  }

  Widget showOptions(String title, Map<String, Map<String, dynamic>> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          itemBuilder: (context, index) {
            String optionName = options.keys.elementAt(index);
            String imagePath = options[optionName]!['image'];
            int price = options[optionName]!['price'];

            return Card(
              color: Colors.brown.shade50,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Image.asset(imagePath, width: 40, height: 40),
                title: Text(optionName),
                subtitle: Text('৳$price'),

                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    selectedCategory = optionName;
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget selectedOptionDisplay() {
    String? imagePath;
    int? price;

    if (gurOptions.containsKey(selectedCategory)) {
      imagePath = gurOptions[selectedCategory]!['image'];
      price = gurOptions[selectedCategory]!['price'];
    } else if (telOptionsWithImage.containsKey(selectedCategory)) {
      imagePath = telOptionsWithImage[selectedCategory]!['image'];
      price = telOptionsWithImage[selectedCategory]!['price'] as int?;
    } else if (moslaOptionsWithImage.containsKey(selectedCategory)) {
      imagePath = moslaOptionsWithImage[selectedCategory]!['image'];
      price = moslaOptionsWithImage[selectedCategory]!['price'];
    } else if (specialItemOptionsWithImageAndPrice.containsKey(
      selectedCategory,
    )) {
      imagePath =
          specialItemOptionsWithImageAndPrice[selectedCategory]!['image'];
      price =
          specialItemOptionsWithImageAndPrice[selectedCategory]!['price']
              as int?;
    }

    if (selectedCategory != null && imagePath != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected: $selectedCategory',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Image.asset(imagePath, width: 100, height: 100),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
