import 'package:flutter/material.dart';
import 'package:flutter_base/app/base/state_view.dart';
import 'package:flutter_base/app/page/product/product_controller.dart';
import 'package:flutter_base/app/widgets/colors.dart';
import 'package:flutter_base/app/widgets/common_widget.dart';
import 'package:flutter_base/domain/entities/product_model.dart';
import 'package:get/get.dart';

class ProductView extends View {
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends ViewState<ProductView, ProductController> {
  List<Widget> toListWidget(List<String> list) {
    return (list.map((item) => CategoryItem(item: item)).toList());
  }

  @override
  void initState() {
    super.initState();
    controller.fetchListProduct();
    controller.fetchListCategory();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back(result: controller.listSelected);
                  }),
              title: Text("Sản Phẩm"),
              centerTitle: true,
              backgroundColor: keyColor,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Danh mục sản phẩm (${controller.listProduct.length})",
                        style: TextStyle(
                            fontSize: 18,
                            color: keyColor,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          size: 30,
                        ),
                        color: keyColor,
                        onPressed: () {
                          controller.listSort.clear();
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: this.context,
                              builder: (BuildContext bc) {
                                return Wrap(
                                    children:
                                        toListWidget(controller.listCategory));
                              }).then(
                            (value) {
                              controller.sortByCategory();
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.listProduct.length,
                    itemBuilder: (context, index) {
                      return ProductItem(item: controller.listProduct[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          loading(status: controller.status.value, context: context)
        ],
      );
    });
  }
}

class ProductItem extends StatefulWidget {
  final ProductModel item;

  ProductItem({@required this.item});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  ProductController controller = Get.find();
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: check ? keyColor : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(width: 1, color: keyColor)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
        ),
        child: ListTile(
            onTap: () {
              if (controller.listSelected.contains(widget.item)) {
                controller.listSelected
                    .removeWhere((item) => item == widget.item);
                setState(() {
                  check = false;
                });
              } else {
                controller.listSelected.add(widget.item);
                setState(() {
                  check = true;
                });
              }
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: check ? Colors.white : keyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  widget.item.price.toString() + "đ",
                  style: TextStyle(
                    fontSize: 16,
                    color: check ? Colors.white : keyColor,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.info),
              color: check ? Colors.white : keyColor,
              iconSize: 25,
              onPressed: () {},
            )),
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String item;
  CategoryItem({@required this.item});

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  ProductController controller = Get.find();
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          if (controller.listSort.contains(widget.item)) {
            controller.listSort.removeWhere((item) => item == widget.item);
            setState(() {
              check = false;
            });
          } else {
            controller.listSort.add(widget.item);
            setState(() {
              check = true;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: keyColor),
            color: check ? keyColor : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.item,
              maxLines: 1,
              style: new TextStyle(
                fontSize: 16,
                color: check ? Colors.white : keyColor,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
          // child: AutoSizeText.rich(
          //   TextSpan(text: widget.item),
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: keyColor,
          //   ),
          //   minFontSize: 10,
          // ),
        ),
      ),
    );
  }
}