import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/components.dart';
import '../constants.dart';
import '../models/models.dart';
import 'checkout_page.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  final CartManager cartManager;
  final OrderManager ordersManager;

  const RestaurantPage({
    super.key,
    required this.restaurant,
    required this.cartManager,
    required this.ordersManager
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const desktopThreshold = 700;
  static const double drawerWidth = 375.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
            ? screenWidth * largeScreenPercentage
            : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    const desktopThreshold = 700;
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildGridViewSection('Menu'),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
            child: Stack(
              children: [
                Hero(
                  tag: 'restaurant-image-${widget.restaurant.id}',
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: DecorationImage(
                            image: AssetImage(widget.restaurant.imageUrl),
                            fit: BoxFit.cover)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    final restaurant = widget.restaurant;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.name, style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text(restaurant.address, style: textTheme.bodySmall)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(restaurant.rating.toString(), style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${restaurant.distance} miles', style: textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            if (restaurant.attributes.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(restaurant.attributes, style: textTheme.labelSmall),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.restaurant.items[index];
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showBottomSheet(item),
        borderRadius: BorderRadius.circular(12),
        child: RestaurantItem(item: item),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  GridView _buildGridView(int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.0,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) => _buildGridItem(index),
      itemCount: widget.restaurant.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  SliverToBoxAdapter _buildGridViewSection(String title) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            _sectionTitle(title),
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(Item item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ItemDetails(
          item: item, 
          cartManager: widget.cartManager,
          quantityUpdated: () {
            setState(() {});
          },),
      ),
    );
  }

  Widget _buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: CheckoutPage(
        cartManager: widget.cartManager,
        didUpdate: () {
          setState(() {});
        },
        onSubmit: (order) {
          widget.ordersManager.addOrder(order);
          context.pop();
          context.go('/${YummyTab.orders.value}');
        },
      )),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget _buildFloatingActionButton() {
    if (widget.cartManager.items.isEmpty) return const SizedBox.shrink();
    
    return FloatingActionButton.extended(
      onPressed: openDrawer,
      tooltip: 'Cart',
      elevation: 4,
      icon: const Icon(Icons.shopping_cart),
      label: Text('${widget.cartManager.items.length} Items in cart'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildEndDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
    );
  }
}
