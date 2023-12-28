import pymysql
import random
from pythonping import ping
from sshtunnel import SSHTunnelForwarder
from flask import Flask, request, jsonify

# The IP address of the manager and worker nodes
managerNode = ""
workerNodes = ["", "", ""]

app = Flask(__name__)

@app.route('/direct', methods=['GET', 'POST'])
def handleDirectRequest():
    # Get the SQL query
    body = request.get_data(as_text=True)

    # Directly forward the request to the master node
    node = managerNode

    # Send the request
    result = implementRequest(node, body)
    return jsonify(result)

@app.route('/random', methods=['GET', 'POST'])
def handleRandomRequest():
    # Get the SQL query
    body = request.get_data(as_text=True)

    # Randomly choose a worker node
    node = random.choice(workerNodes)

    # Send the request
    result = implementRequest(node, body)
    return jsonify(result)

@app.route('/customized', methods=['GET', 'POST'])
def handleCustomizedRequest():
    # Get the SQL query
    body = request.get_data(as_text=True)

    # Find the node with the best response time
    bestNode = None
    minPing = float('inf')
    for node in workerNodes:
        avgPing = ping(node, count=3).rtt_avg_ms
        if avgPing < minPing:
            minPing = avgPing
            bestNode = node
    node = bestNode

    # Send the request
    result = implementRequest(node, body)
    return jsonify(result)

def implementRequest(node, query):
    with SSHTunnelForwarder(node, ssh_username='ubuntu', ssh_pkey='TP3_Key.pem',
                            remote_bind_address=(managerNode, 3306)):
        conn = pymysql.connect(host=managerNode, user='ubuntu', password='password', db='sakila', port=3306, autocommit=True)
        cursor = conn.cursor()
        operation = query
        cursor.execute(operation)
        result = cursor.fetchall()
        conn.close()
        print(result)
        return result

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
