from email.message import EmailMessage
import smtplib
import flask
from flask import Flask, request
app = Flask(__name__)


@app.route('/mail')
def mail():
    args = request.args

    message = EmailMessage()
    sender = 'orders.suneelprinters@gmail.com'
    recipient = args['email']

    message['From'] = sender
    message['To'] = recipient

    message['Subject'] = 'Order Confirmation from Sunil Printers'
    message.set_content( f"Dear {args['customer']}\nGreetings from Sunil Printers!\n\nThis is to confirm that your order for a {args['productName']} costing Rs. {args['price']} is placed. It would be shortly delivered to the following address\n\n {args['address']}\n\n Thanks for Shopping with us!")
    mail_server = smtplib.SMTP_SSL('smtp.gmail.com')
    mail_server.login('orders.suneelprinters@gmail.com', 'SuneelPrinters37')
    mail_server.send_message(message)
    mail_server.quit()
    return 'Mail is Sent'

if __name__ == '__main__':
    app.run(debug=True, port=5000)


