import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String? initialSelectedCategory; // initial category

  const CategoryScreen({Key? key, this.initialSelectedCategory}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> categories = ['গুড়', 'তেল', 'মসলা', 'Special Item'];
  String? selectedCategory;

  final Map<String, String> gurOptionsWithImage = {
    'ঘোলা গুড়': 'assets/images/8521_FLEUR_DE_TOFEEWEB.jpg',
    'বিজ গুড়': 'assets/images/black-urad-laddu-recipe7-min.jpg',
    'নারকেল গুড়': 'assets/images/vegan-skillet-cornbread-480x480.jpg',
    'দানাদার গুড়': 'assets/images/_41_frd_1731470695.jpg',
    'চকলেট গুড়': 'assets/images/Banoffee-Choc.jpg',
    'পাটালি গুড়': 'assets/images/patali-gur-web.png',
  };

  final Map<String, String> telOptionsWithImage = {
    'নারকেল তেল': 'assets/images/1731220762-f64714028e196b87c87dbde76bcdeb59.jpg',
    'সরিষা তেল': 'assets/images/80.jpg',
  };

  final Map<String, String> moslaOptionsWithImage = {
    'মরিচ': 'assets/images/morich.jpg',
    'হলুদ': 'assets/images/holud.jpg',
    'জিরা': 'assets/images/jira.jpg',
    'ধনিয়া': 'assets/images/dhaniya.jpg',
    'গরম মশলা': 'assets/images/gorom_mosla.jpg',
  };

  final Map<String, String> specialItemOptionsWithImage = {
    'খোলিসা মধু': 'assets/images/mohu.jpg',
    'কুমড়ো বরি': 'assets/images/komro.jpg',
    'ঘি': 'assets/images/ghi.jpg',
    'চালের গুড়া': 'assets/images/chaler_gura.jpg',
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
          IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: () {}),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            if (selectedCategory == 'গুড়') showOptions('গুড় এর ধরনসমূহ', gurOptionsWithImage),
            if (selectedCategory == 'তেল') showOptions('তেলের ধরনসমূহ', telOptionsWithImage),
            if (selectedCategory == 'মসলা') showOptions('মসলার ধরনসমূহ', moslaOptionsWithImage),
            if (selectedCategory == 'Special Item') showOptions('Special Item', specialItemOptionsWithImage),
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

  Widget showOptions(String title, Map<String, String> optionsWithImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: optionsWithImage.length,
          itemBuilder: (context, index) {
            String optionName = optionsWithImage.keys.elementAt(index);
            String imagePath = optionsWithImage[optionName]!;
            return Card(
              color: Colors.brown.shade50,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Image.asset(imagePath, width: 40, height: 40),
                title: Text(optionName),
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

    if (gurOptionsWithImage.containsKey(selectedCategory)) {
      imagePath = gurOptionsWithImage[selectedCategory];
    } else if (telOptionsWithImage.containsKey(selectedCategory)) {
      imagePath = telOptionsWithImage[selectedCategory];
    } else if (moslaOptionsWithImage.containsKey(selectedCategory)) {
      imagePath = moslaOptionsWithImage[selectedCategory];
    } else if (specialItemOptionsWithImage.containsKey(selectedCategory)) {
      imagePath = specialItemOptionsWithImage[selectedCategory];
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
