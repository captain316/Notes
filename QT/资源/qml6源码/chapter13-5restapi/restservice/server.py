#region global
#region setup
from flask import Flask, jsonify, request
import json

with open('colors.json', 'r') as file:
    colors = json.load(file)

app = Flask(__name__)
#endregion setup

#region get-colors
@app.route('/colors', methods = ['GET'])
def get_colors():
    return jsonify({ "data" : colors })
#endregion get-colors

#region get-color
@app.route('/colors/<name>', methods = ['GET'])
def get_color(name):
    for color in colors:
        if color["name"] == name:
            return jsonify(color)
    return jsonify({ 'error' : True })
#endregion get-color

#region create-color
@app.route('/colors', methods= ['POST'])
def create_color():
    print('create color')
    color = {
        'name': request.json['name'],
        'value': request.json['value']
    }
    colors.append(color)
    return jsonify(color), 201
#endregion create-color

#region update-color
@app.route('/colors/<name>', methods= ['PUT'])
def update_color(name):
    for color in colors:
        if color["name"] == name:
            color['value'] = request.json.get('value', color['value'])
            return jsonify(color)
    return jsonify({ 'error' : True })
#endregion update-color

#region delete-color
@app.route('/colors/<name>', methods=['DELETE'])
def delete_color(name):
    for color in colors:
        if color["name"] == name:
            colors.remove(color)
            return jsonify(color)
    return jsonify({ 'error' : True })
#endregion delete-color

# region main
if __name__ == '__main__':
    app.run(debug = True)
# endregion main

#endregion global
