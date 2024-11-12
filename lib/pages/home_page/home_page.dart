import 'package:flutter/material.dart';
import 'package:price_match_app_ui/common/widgets/section_heading.dart';
import 'package:price_match_app_ui/pages/home_page/widgets/welcome_banner.dart';
import 'package:price_match_app_ui/pages/search_page/search_page.dart';
import 'package:price_match_app_ui/pages/product_details_page/product_details_page.dart';
import 'package:price_match_app_ui/services/mock_data.dart';
import '../../models/product.dart';

import '../setting_page/setting_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> featuredProducts = [];
  List<String> recentSearches = ['testing1', 'testing2', 'testing3']; // This should come from user history

  @override
  void initState() {
    super.initState();
    // TODO: API to get 5 product for the user (maybe recommended product)
    featuredProducts = MockData.sampleProduct.take(5).toList();
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          productName: product.productName,
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredProducts.length,
        itemBuilder: (context, index) {
          final product = featuredProducts[index];
          return GestureDetector(
            onTap: () => _navigateToProductDetails(product),
            child: Container(
              width: 160,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      'https://via.placeholder.com/150' ?? 'https://via.placeholder.com/150',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.blue.shade100,
                          child: Icon(Icons.broken_image, color: Colors.blue.shade800),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.productName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\$255',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recent Searches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          children: recentSearches.map((search) {
            return ActionChip(
              label: Text(search),
              onPressed: () {
                // Implement navigation to search results for the tapped search term
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
                // Optionally, prefill the search query
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Optionally, you can add a bottom navigation bar for easy access
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PriceMatch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WelcomeBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToSearch,
                      icon: Icon(Icons.search),
                      label: Text('Search Products'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Featured Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const SectionHeading('Feature Products', 0.0),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // Navigate to SearchPage or a dedicated Featured Products page
                      _navigateToSearch();
                    },
                    child: Text('View All'),
                  ),
                ],
              ),
            ),
            _buildFeaturedProducts(),
            Divider(),
            // Recent Searches Section
            _buildRecentSearches(),
            SizedBox(height: 16),
          ],
        ),
      ),
      // Optionally, you can add a floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSearch,
        child: Icon(Icons.search),
        backgroundColor: Colors.blue.shade800,
        tooltip: 'Search Products',
      ),
    );
  }
}