import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Classes/Product.dart';
import '../Classes/ProductProperty.dart';
import '../Classes/ProductPropertyandValue.dart';
import '../Classes/ProductVariation.dart';
import '../Providers/VariantProvider.dart';
import '../UtilityFunctions.dart';
import 'package:provider/provider.dart';

class PropertySelectorWidget extends StatefulWidget {
  final List<ProductPropertyandValue> productPropertiesValues;
  final String property;
  final Product product;
  final ProductVariation currentVariant;

  PropertySelectorWidget({
    Key? key,
    required this.productPropertiesValues,
    required this.property,
    required this.currentVariant,
    required this.product,
  }) : super(key: key);

  @override
  _PropertySelectorWidgetState createState() => _PropertySelectorWidgetState();
}

class _PropertySelectorWidgetState extends State<PropertySelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'select the preferred ${widget.property}:',
        //   style: const TextStyle(fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 8),
        buildPropertyOption()!,
      ],
    );
  }

  // Color _parseColor(String color) {
  //   try {
  //     return Color(int.parse(color));
  //   } catch (e) {
  //     // Handle the exception, for example, return a default color.
  //     return Colors.grey; // You can choose a default color.
  //   }
  // }

  //! temporary & terrible solution
  Color getColorFromString(String colorName) {
    //TODO: fix this by using colors as hex values
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.orange; // Default color for unknown names
    }
  }

  Widget? buildPropertyOption() {
    // ProductPropertyandValue? propertyValue =
    // getPropertyAndValue(widget.property);

    if (widget.property == 'color') {
      if (kDebugMode) {
        print('building color selector');
      }
      List<String> possibleColors =
          getOtherColors(widget.product.variations, widget.currentVariant);
      if (possibleColors.isNotEmpty) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (String color in possibleColors)
            InkWell(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: getColorFromString(color),
                  shape: BoxShape.circle,
                  border: widget.currentVariant.getColorValue() == color
                      ? Border.all(
                    color: color == 'black' ? Colors.grey : Colors.black,
                    width: widget.currentVariant.getColorValue() == color ? 5.0 : 2.0,
                  )
                      : null, // No border for unselected colors
                ),
              ),
              onTap: () {
                if (kDebugMode) {
                  print(' finding product with color: $color');
                }
                // widget.currentVariant.printVariationDetails();
                // print product property values
                for (ProductPropertyandValue propertyValue
                    in widget.productPropertiesValues) {
                  if (kDebugMode) {
                    print('${propertyValue.property}: ${propertyValue.value}');
                  }
                }
                context.read<VariantProvider>().setCurrentVariant(
                      newVariant: widget.product.getVariationByPropertiesValues(
                        productPropertiesValues: [
                          ProductPropertyandValue(
                            property: 'color',
                            value: color,
                          ),
                          ProductPropertyandValue(
                            property: 'size',
                            value: widget.currentVariant.getSizeValue(),
                          ),
                          ProductPropertyandValue(
                            property: 'material',
                            value: widget.currentVariant.getMaterialValue(),
                          ),
                        ],
                      ),
                    );
              },
            ),
        ]);
      }
    } else if (widget.property == 'size') {
      if (kDebugMode) {
        print('building size selector');
      }
      List<String> possibleSizes =
          getOtherSizes(widget.product.variations, widget.currentVariant);
      if (possibleSizes.isNotEmpty) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (String size in possibleSizes)
              InkWell(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Change to the appropriate color
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.currentVariant.getSizeValue() == size
                          ? Colors.black
                          : Colors.grey,
                      width: widget.currentVariant.getSizeValue() == size
                          ? 5.0
                          : 2.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        color: widget.currentVariant.getSizeValue() == size
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (kDebugMode) {
                    print('finding product with size: $size');
                  }
                  // widget.currentVariant.printVariationDetails();
                  // Print product property values
                  for (ProductPropertyandValue propertyValue in widget.productPropertiesValues) {
                    if (kDebugMode) {
                      print('${propertyValue.property}: ${propertyValue.value}');
                    }
                  }
                  context.read<VariantProvider>().setCurrentVariant(
                    newVariant: widget.product.getVariationByPropertiesValues(
                      productPropertiesValues: [
                        ProductPropertyandValue(
                          property: 'color',
                          value: widget.currentVariant.getColorValue(),
                        ),
                        ProductPropertyandValue(
                          property: 'size',
                          value: size,
                        ),
                        ProductPropertyandValue(
                          property: 'material',
                          value: widget.currentVariant.getMaterialValue(),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      }
    } else if (widget.property == 'material') {
      if (kDebugMode) {
        print('building material selector');
      }
      List<String> possibleMaterials =
          getOtherMaterials(widget.product.variations, widget.currentVariant);
      if (possibleMaterials.isNotEmpty) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (String material in possibleMaterials)
              InkWell(
                child: Container(
                  width: 80, // Adjust the width as needed
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Change to the appropriate color
                    borderRadius: BorderRadius.circular(25), // Stadium border
                    border: Border.all(
                      color:
                          widget.currentVariant.getMaterialValue() == material
                              ? Colors.black
                              : Colors.grey,
                      width:
                          widget.currentVariant.getMaterialValue() == material
                              ? 5.0
                              : 2.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      material,
                      style: TextStyle(
                        color:
                            widget.currentVariant.getMaterialValue() == material
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (kDebugMode) {
                    print('finding product with material: $material');
                  }
                  // widget.currentVariant.printVariationDetails();
                  // Print product property values
                  for (ProductPropertyandValue propertyValue in widget.productPropertiesValues) {
                    if (kDebugMode) {
                      print('${propertyValue.property}: ${propertyValue.value}');
                    }
                  }
                  context.read<VariantProvider>().setCurrentVariant(
                    newVariant: widget.product.getVariationByPropertiesValues(
                      productPropertiesValues: [
                        ProductPropertyandValue(
                          property: 'color',
                          value: widget.currentVariant.getColorValue(),
                        ),
                        ProductPropertyandValue(
                          property: 'size',
                          value: widget.currentVariant.getSizeValue(),
                        ),
                        ProductPropertyandValue(
                          property: 'material',
                          value: material,
                        ),
                      ],
                    ),
                  );
                },

              ),
          ],
        );
      }
    } else {
      return const Text('N/A');
    }
    return null;

    // return propertyValue != null
    //     ? Text('${property.property}: ${propertyValue.value}')
    //     : Text('${property.property}: N/A');
  }

  ProductPropertyandValue? getPropertyAndValue(String property) {
    for (ProductPropertyandValue propertyValue
        in widget.productPropertiesValues) {
      if (propertyValue.property == property) {
        return propertyValue;
      }
    }
    return null;
  }
}
