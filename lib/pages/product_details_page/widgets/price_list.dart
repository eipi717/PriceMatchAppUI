import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/history_price.dart';

class PriceList extends StatelessWidget {
  final List<HistoryPrice> prices;

  const PriceList(this.prices, {super.key});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No price history available.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prices.length,
      itemBuilder: (context, index) {
        final price = prices[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              backgroundImage: AssetImage('assets/images/${price.storeName}_logo.jpeg'),
            ),
            title: Text(
              DateFormat('MMMM d, yyyy').format(price.dateOfPrice),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              price.storeName,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            trailing: Text(
              '\$${price.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            onTap: () {
              // Show detailed dialog when a list item is tapped
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('${price.storeName} Details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${DateFormat('MMMM d, yyyy').format(price.dateOfPrice)}',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: \$${price.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      // Add more details if necessary
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                      const Text('Close', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}