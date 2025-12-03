import 'package:flutter/material.dart';
import 'package:medicine_reminder/pages/medicine_list/medicine_details.dart';

class MedicineListPage extends StatefulWidget {
  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  final List<Map<String, String>> medicines = [
    {
      'name': 'Paracetamol',
      'description': 'Fever reducer and pain reliever',
      'image':
      'https://phabcart.imgix.net/cdn/scdn/images/uploads/m0459_web.jpg'
    },
    {
      'name': 'Ibuprofen',
      'description': 'Pain Reliever',
      'image':
      'https://i5.walmartimages.com/seo/Equate-Ibuprofen-Mini-Softgel-Capsules-200-mg-160-Count_d2498da5-b4b9-4363-b143-0c6d24ff1286.9e764a0673ce90582406c072c0a0861b.jpeg'
    },
    {
      'name': 'Loratadine',
      'description': 'Antihistamine',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbLlJgKzKNIdSb_VFB0ChHX6PWBZgdEWjizw&s'
    },
    {
      'name': 'Cetirizine',
      'description': 'Antihistamine',
      'image':
      'https://cdn11.bigcommerce.com/s-0hgi7r5fnp/images/stencil/1280x1280/products/113/517/zista_100-2__68276.1698542802.png?c=1'
    },
    {
      'name': 'Diphenhydramine',
      'description': 'Antihistamine',
      'image':
      'https://images.ctfassets.net/za5qny03n4xo/1eMhurqw0cnm90opZD7rUQ/b2ec4b89f1525c034d417d9756f3ec04/ah_side_0.png'
    },
    {
      'name': 'Ranitidine',
      'description': 'Reduces stomach acid',
      'image':
      'https://image.made-in-china.com/2f0j00ryubDWtsgvcT/Ranitidine-Hydrochloride-Injection-50mg-2ml.webp'
    },
    {
      'name': 'Lansoprazole',
      'description': 'Reduces stomach acid',
      'image':
      'https://res.cloudinary.com/zava-www-uk/image/upload/a_exif,f_auto,e_sharpen:100,c_fit,w_800,h_600,fl_lossy/v1706805554/sd/uk/services-setup/acid-reflux/lansoprazole/azwwqs0qjupaekmmqqr8.png'
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredMedicines = medicines
        .where((medicine) =>
        medicine['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Medicine List'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Medicines',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Medicine List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = filteredMedicines[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MedicineDetailsPage(
                          imageUrl: medicine['image']!,
                          medicineName: medicine['name']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          medicine['image']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        medicine['name']!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepPurple[700]),
                      ),
                      subtitle: Text(
                        medicine['description']!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.deepPurpleAccent,
                        size: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
