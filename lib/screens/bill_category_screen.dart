import 'package:flutter/material.dart';
import 'package:btih_andriod_app/models/bill_category_model.dart';
import 'package:btih_andriod_app/services/bill_category_service.dart';

class BillCategoryScreen extends StatefulWidget {
  const BillCategoryScreen({super.key});

  @override
  State<BillCategoryScreen> createState() => _BillCategoryScreenState();
}

class _BillCategoryScreenState extends State<BillCategoryScreen> {
  late Future<List<BillCategory>> billCategories;

  @override
  void initState() {
    super.initState();
    billCategories = BillCategoryService().getBillCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Categories'),
      ),
      body: FutureBuilder<List<BillCategory>>(
        future: billCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].billCatName),
                  subtitle: Text(
                    '${snapshot.data![index].billCatId} ${snapshot.data![index].isActive} ${snapshot.data![index].dcType}',
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
