import 'package:flutter/material.dart';
import '/models/product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width * 0.25;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.fill,
          // ),
        ),
        title: Text(product.title),
        trailing: Container(
          width: w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
