import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_match_app_ui/models/price.dart';
import 'package:price_match_app_ui/pages/product_details_page/widgets/price_list.dart';
import 'package:price_match_app_ui/services/history_prices_services.dart';
import 'package:price_match_app_ui/services/mock_data.dart';
import 'package:price_match_app_ui/services/price_services.dart';

import '../../models/history_price.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;

  const ProductDetailsPage({Key? key, required this.productName}) : super(key: key);


  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  String? selectedStore = 'All Stores';
  List<HistoryPrice> filteredPrices = [];
  List<HistoryPrice> pricesList = [];

  // Date range filter
  DateTimeRange? selectedDateRange;

  // To store the selected data point
  HistoryPrice? selectedPrice;

  HistoryPricesServices historyPricesServices = HistoryPricesServices();

  @override
  void initState() {
    super.initState();
    _fetchPrice();
    _filterPrices(selectedStore);
  }

  Future<void> _fetchPrice() async {
    print('start!');
    List<HistoryPrice> historyPricesList = await historyPricesServices.getPricesByProductName(widget.productName);
    print('end!');
    setState(() {
      filteredPrices = historyPricesList;
      pricesList = historyPricesList;
    });
  }

  void _filterPrices(String? storeName) {
    print(filteredPrices);
    // _fetchPrice();
    // print(filteredPrices);
    setState(() {
      print('set state now ...');
      selectedStore = storeName;
      filteredPrices = pricesList
          .where((price) =>
      storeName == 'All Stores' || price.storeName == storeName)
          .toList();

      // Apply date range filter if selected
      if (selectedDateRange != null) {
        filteredPrices = pricesList.where((price) {
          return price.dateOfPrice.isAfter(selectedDateRange!.start.subtract(Duration(days: 1))) && // Inclusive start
              price.dateOfPrice.isBefore(selectedDateRange!.end.add(Duration(days: 1))); // Inclusive end
        }).toList();
      }

      // Sort the prices by date to ensure the chart is accurate
      filteredPrices.sort((a, b) => a.dateOfPrice.compareTo(b.dateOfPrice));

      // Aggregate prices by date to remove duplicates
      filteredPrices = _aggregatePricesByDate(filteredPrices);

      // Keep only the latest five data points
      if (filteredPrices.length > 5) {
        filteredPrices = filteredPrices.sublist(filteredPrices.length - 5);
      }

      // Reset selectedPrice when filter changes to avoid referencing a non-existent price
      selectedPrice = null;
    });
  }

  /// Aggregates HistoryPrice entries by date, taking the latest price for each date.
  List<HistoryPrice> _aggregatePricesByDate(List<HistoryPrice> prices) {
    Map<String, HistoryPrice> datePriceMap = {};

    for (var price in prices) {
      String dateKey = DateFormat('yyyy-MM-dd').format(price.dateOfPrice);
      // Assuming the list is sorted by date ascending
      datePriceMap[dateKey] = price; // This will keep the latest entry for each date
    }

    return datePriceMap.values.toList();
  }

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = filteredPrices.isNotEmpty
        ? filteredPrices.first.dateOfPrice
        : now.subtract(const Duration(days: 365)); // Default to last year
    final DateTime lastDate = filteredPrices.isNotEmpty
        ? filteredPrices.last.dateOfPrice
        : now;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange ??
          DateTimeRange(start: firstDate, end: lastDate),
      firstDate: firstDate.subtract(const Duration(days: 365)), // 1 year before
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        _filterPrices(selectedStore);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeNames = MockData.storeNames;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting store and Date Filter Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Expanded Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Store',
                        prefixIcon: Icon(Icons.store),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: selectedStore,
                      onChanged: _filterPrices,
                      items: storeNames.map((storeName) {
                        return DropdownMenuItem<String>(
                          value: storeName,
                          child: Text(storeName),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Date Range Picker Button
                  ElevatedButton.icon(
                    onPressed: _selectDateRange,
                    icon: Icon(Icons.date_range),
                    label: Text('Filter Date'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display selected date range
            if (selectedDateRange != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue.shade600),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${DateFormat('MMM d, yyyy').format(selectedDateRange!.start)} - ${DateFormat('MMM d, yyyy').format(selectedDateRange!.end)}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.red.shade600),
                      onPressed: () {
                        setState(() {
                          selectedDateRange = null;
                          _filterPrices(selectedStore);
                        });
                      },
                      tooltip: 'Clear Date Filter',
                    ),
                  ],
                ),
              ),
            // Price Chart
            _buildPriceChart(filteredPrices),
            // Title for Price History
            const Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Price History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Price List
            PriceList(filteredPrices),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChart(List<HistoryPrice> prices) {
    if (prices.isEmpty) {
      return const Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No data available for the selected store and date range.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Aggregate prices by date to ensure unique dates
    List<HistoryPrice> uniquePrices = _aggregatePricesByDate(prices);

    // Ensure uniquePrices are sorted
    uniquePrices.sort((a, b) => a.dateOfPrice.compareTo(b.dateOfPrice));

    // Calculate the difference in days from the first date
    DateTime firstDate = uniquePrices.first.dateOfPrice;
    List<FlSpot> spots = uniquePrices.map((price) {
      double x = price.dateOfPrice.difference(firstDate).inDays.toDouble();
      double y = price.price;
      return FlSpot(x, y);
    }).toList();

    // Map x-values to formatted date strings for labels
    Map<double, String> xLabels = {};
    for (var price in uniquePrices) {
      double x = price.dateOfPrice.difference(firstDate).inDays.toDouble();
      String label = DateFormat('MMM d').format(price.dateOfPrice);
      xLabels[x] = label;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxWidth * 0.6, // Adjusted aspect ratio
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: uniquePrices.last.dateOfPrice
                      .difference(firstDate)
                      .inDays
                      .toDouble(),
                  minY: uniquePrices
                      .map((price) => price.price)
                      .reduce((a, b) => a < b ? a : b) *
                      0.95, // 5% padding below
                  maxY: uniquePrices
                      .map((price) => price.price)
                      .reduce((a, b) => a > b ? a : b) *
                      1.05, // 5% padding above
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          String date = xLabels[spot.x] ?? '';
                          return LineTooltipItem(
                            '$date\n\$${spot.y.toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? response) {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.lineBarSpots == null) return;
                      final spot = response.lineBarSpots!.first;
                      setState(() {
                        // Optionally, handle the selected spot here
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: uniquePrices.length > 5
                            ? (uniquePrices.last.dateOfPrice
                            .difference(firstDate)
                            .inDays /
                            4)
                            : 1,
                        getTitlesWidget: (value, meta) {
                          String label = xLabels[value] ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              label,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: ((uniquePrices
                            .map((p) => p.price)
                            .reduce((a, b) => a > b ? a : b) *
                            1.05) -
                            (uniquePrices
                                .map((p) => p.price)
                                .reduce((a, b) => a < b ? a : b) *
                                0.95)) /
                            5, // 5 labels
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue.shade600,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}