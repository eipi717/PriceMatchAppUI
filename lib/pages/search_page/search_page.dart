import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_match_app_ui/common/constants/setting_constants.dart';
import 'package:price_match_app_ui/common/constants/style_constants.dart';
import 'package:price_match_app_ui/services/product_services.dart';

import '../../common/enum.dart';
import '../../models/product.dart';
import '../product_details_page/product_details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProductServices productServices = ProductServices();
  List<Product> displayedProductList = [];
  Timer? debounce;
  int page = 1;
  int size = 10;

  TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Category filter
  String selectedCategory = SettingsConstants.allCategory;
  List<String> categories = [SettingsConstants.allCategory];

  // Sorting
  SortOption? selectedSortOption;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    _fetchProducts(page, size);
  }

  Future<void> _fetchProducts(int page, int size) async {
    List<Product> productList = await productServices.getAllProductsWithPrice(page, size);
    setState(() {
      displayedProductList = [... displayedProductList, ...productList];
      // Initialize categories based on product data if needed
      categories.addAll(
        productList.map((product) => product.productCategory).toSet().toList(),
      );
    });
  }

  Future<void> _searchProduct(String query) async {
    List<Product> productList = await productServices.searchProduct(query);
    setState(() {
      displayedProductList = productList;
      print(displayedProductList.length);
    });
  }

  void _onScroll() {
    // Scroll to bottom to load next page
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && searchController.text.isEmpty) {
      print('query is empty!');
      page += 1;
      _fetchProducts(page, size);
    }
  }

  void _searchValueOnChange(String updatedQuery) {
    // Cancel previous timer
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(seconds: 1), () {
      setState(() {
        _filterProducts(updatedQuery, selectedCategory, selectedSortOption);
      });
    });
  }

  void _clearSearchResult() {
    setState(() {
      searchController.text = "";
      _filterProducts("", selectedCategory, selectedSortOption);
    });
  }

  void _filterProducts(String query, String category, SortOption? sortOption) {
    _searchProduct(query);
    List<Product> tempList = displayedProductList.where((product) {
      final matchesCategory = category == SettingsConstants.allCategory || product.productCategory == category;
      return matchesCategory;
    }).toList();

    // Apply sorting
    if (sortOption != null) {
      switch (sortOption) {
        case SortOption.nameAsc:
          tempList.sort((a, b) => a.productName.compareTo(b.productName));
          break;
        case SortOption.nameDesc:
          tempList.sort((a, b) => b.productName.compareTo(a.productName));
          break;
        case SortOption.categoryAsc:
          tempList.sort((a, b) => a.productCategory.compareTo(b.productCategory));
          break;
        case SortOption.categoryDesc:
          tempList.sort((a, b) => b.productCategory.compareTo(a.productCategory));
          break;
      }
    }

    displayedProductList = tempList;
  }

  void _selectCategory(String? category) {
    if (category == null) return;
    setState(() {
      selectedCategory = category;
      _filterProducts(searchController.text, selectedCategory, selectedSortOption);
    });
  }

  void _selectSortOption(SortOption option) {
    setState(() {
      selectedSortOption = option;
      _filterProducts(searchController.text, selectedCategory, selectedSortOption);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        actions: [
          // Sorting Options
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: _selectSortOption,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.nameAsc,
                child: Text(SettingsConstants.sortByNameASC),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.nameDesc,
                child: Text(SettingsConstants.sortByNameDESC),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.categoryAsc,
                child: Text(SettingsConstants.sortByCategoryASC),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.categoryDesc,
                child: Text(SettingsConstants.sortByCategoryDESC),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: StyleConstants.containerMarginHorizontal, vertical: StyleConstants.containerMarginVertical),
            child: Row(
              children: [
                // Expanded Search Bar
                // TODO: Need to be improved
                Expanded(
                  flex: StyleConstants.searchBarFlex,
                  child: TextField(
                    controller: searchController,
                    onChanged: _searchValueOnChange,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: SettingsConstants.searchBarInnerText,
                      prefixIcon: const Icon(Icons.search_rounded, color: Colors.blue),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                        onPressed: _clearSearchResult,
                      )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: StyleConstants.searchBarPaddingHorizontal, vertical: StyleConstants.searchBarPaddingVertical),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(StyleConstants.searchBarBorderRadius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Constrained Category Dropdown
                Container(
                  width: 200, // Set a maximum width to prevent overflow
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category, color: Colors.blue),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedCategory,
                    onChanged: _selectCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Display message when no products are found
          if (displayedProductList.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No products found',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          // Improved product list with animations and dummy images
          Expanded(
            child: displayedProductList.isNotEmpty
                ? ListView.builder(
              controller: scrollController,
              itemCount: displayedProductList.length,
              itemBuilder: (context, index) {
                final product = displayedProductList[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.blue.shade100,
                            child: Icon(Icons.broken_image, color: Colors.blue.shade800),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      product.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productCategory,
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                        ),
                        SizedBox(height: 4), // Small spacing between texts
                        Text(
                          'Last updated: ${DateFormat('MMM d yyyy').format(product.updateTime)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '\$${product.currentPrice}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            productName: product.productName,
                          ),
                        ),
                      );

                    },
                  ),
                );
              },
            )
                : const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No products available.',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}