import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/cart.dart';
import 'package:suneel_printer/models/product.dart';

String mailTemplate(String name, String phone, String address, double price) =>
    ''''<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
         body {
         background-color: #F0F0F0;
         font-family: sans-serif;
         }
         #card {
         background-color: white;
         padding: 4px 32px 32px 32px;
         margin-top: 12px;
         }
         .lefty {
         text-align: left;
         }
         .righty {
         text-align: right;
         }
         .center {
         display: block;
         margin-left: auto;
         margin-right: auto;
         }
         table.product td, table.product th {
         padding-right: 10px;
         padding-left: 10px;
         padding-top: 6px;
         padding-bottom: 6px;
         }
         table.product th {
         border-bottom: 1px solid black;
         }
         table {
         width: 100%;
         border-collapse: collapse;
         }
         table.product {
         margin-top: 18px;
         }
         .fa {
         padding: 16px;
            font-size: 16px;
            width: 16px;
            text-align: center;
            text-decoration: none;
            margin: 5px 2px;
            border-radius: 50%;
          }
         .fa-facebook {
         margin-top: 12px;
            background: #666;
            color: white;
          }
      </style>
</head>
<body>
<img src="https://firebasestorage.googleapis.com/v0/b/suneelprinters37.appspot.com/o/1601965887199_1-removebg-preview.png?alt=media&token=ba3a4023-f558-45cb-a947-82d95aa12244", class="center" width="12%">
<div id="card">
    <p style="font-size: 24px; font-weight: bold; text-align: center;">ORDER DETAILS</p>
    <table>
        <tr>
            <th class="lefty">Customer Name:</th>
            <td class="righty">$name</td>
        </tr>
        <tr>
            <th class="lefty">Phone Number:</th>
            <td class="righty">$phone</td>
        </tr>
        <tr>
            <th class="lefty">Shipping Address:</th>
            <td class="righty" width="50%">$address</td>
        </tr>
    </table>
    <table class="product">
        <tr>
            <th class="lefty">PRODUCT NAME</th>
            <th class="righty">QUANTITY</th>
            <th class="righty" width="40%">PRICE</th>
        </tr>
        ${cart.products.map<String>((CartItem cartItem) {
          Product product = cartItem.product;

          return '''
          <tr>
            <td>${product.name}</td>
            <td class="righty">${cartItem.quantity}</td>
            <td class="righty">${(double.parse(product.price) * cartItem.quantity).toStringAsFixed(2)}</td>
          </tr>
          ''';
        }).toList().join("\n")}
        <tr>
          <th colspan="2" style="border-top: 1px solid black; text-align: left;">TOTAL:</th>
          <th style="border-top: 1px solid black" class="righty">$price</th>
        </tr>
    </table>
</div>
<a href="http://www.facebook.com/" target="_blank">
        <img src="https://simplesharebuttons.com/images/somacro/facebook.png" alt="Facebook" width="4%" class="center" />
    </a>
</body>
</html>''';
