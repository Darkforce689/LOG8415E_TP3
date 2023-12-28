from flask import Flask, request
import requests

# The IP address of the proxy node
proxyNode = ""

app = Flask(__name__)

@app.route('/direct', methods=['GET', 'POST'])
def handleDirectRequest():
    # Get the SQL query
    body = request.form.get('query')

    # Send POST request to the proxy
    if request.method == 'POST':
        response = requests.post(f"http://{proxyNode}/direct", data=body)

    # Send GET request to the proxy
    elif request.method == 'GET':
        response = requests.get(f"http://{proxyNode}/direct", data=body)

    return response.content

@app.route('/random', methods=['GET', 'POST'])
def handleRandomRequest():
    # Get the SQL query
    body = request.form.get('query')

    # Send POST request to the proxy
    if request.method == 'POST':
        response = requests.post(f"http://{proxyNode}/random", data=body)

    # Send GET request to the proxy
    elif request.method == 'GET':
        response = requests.get(f"http://{proxyNode}/random", data=body)

    return response.content

@app.route('/customized', methods=['GET', 'POST'])
def handleCustomizedRequest():
    # Get the SQL query
    body = request.form.get('query')
    
    # Send POST request to the proxy
    if request.method == 'POST':
        response = requests.post(f"http://{proxyNode}/customized", data=body)

    # Send GET request to the proxy
    elif request.method == 'GET':
        response = requests.get(f"http://{proxyNode}/customized", data=body)

    return response.content


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
