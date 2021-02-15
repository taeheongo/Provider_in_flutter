import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/models/cart.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            Divider(height: 4, color: Colors.black),
            _CartTotal(),
            OutlinedButton(
              onPressed: () {
                /*
                  Sometimes, you don’t really need the data in the model to change the UI 
                  but you still need to access it. For example, a ClearCart button wants 
                  to allow the user to remove everything from the cart. It doesn’t need 
                  to display the contents of the cart, it just needs to call the clear() method.
                */
                Provider.of<CartModel>(context, listen: false).removeAll();
              },
              child: Text(
                "remove all",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    var cart = context.watch<CartModel>();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.items[index]);
          },
        ),
        title: Text(
          cart.items[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline1.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
             Another way to listen to a model's change is to include
             the Consumer widget. This widget will automatically listen
             to CartModel and rerun its builder on every change.
            
             The important thing is that it will not rebuild the rest of the widgets in this build method.
             It is best practice to put your Consumer widgets as deep in the tree as possible. 
             You don’t want to rebuild large portions of the UI just because some detail somewhere changed.

             If you don’t specify the generic (<CartModel>), the provider package won’t be able to help you.
             provider is based on types, and without the type, it doesn’t know what you want.
            */
            Consumer<CartModel>(
              builder: (context, cart, child) => Row(
                children: [
                  child,
                  Text('\$${cart.totalPrice}', style: hugeStyle),
                ],
              ),
              /*
                The third argument is child, which is there for optimization. 
                If you have a large widget subtree under your Consumer that doesn’t change 
                when the model changes, you can construct it once and get it through the builder.
              */
              child: Icon(Icons.money),
            ),
            SizedBox(width: 24),
            FlatButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Buying not supported yet.')));
              },
              color: Colors.white,
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
