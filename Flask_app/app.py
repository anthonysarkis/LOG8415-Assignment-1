import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def base_route():
    return '<h1>Instance number {} is responding now!</h1>'.format(os.environ['instanceId'])

@app.route('/cluster1')
@app.route('/cluster2')
def cluster_route():
    return '<h1>Instance number {} is responding now!</h1>'.format(os.environ['instanceId'])


if __name__ == '__main__':
    app.run()
