from flask import Flask, request, jsonify
from flask_cors import CORS
import taiwanesetochinese as ttc
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

@app.route("/", methods = ["POST"])
def start():
    data = request.get_json()
    print(data['text'])
    token = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDUyMzAzMzIsImlhdCI6MTY0MjE1ODMzMiwic3ViIjoiIiwiYXVkIjoid21ta3MuY3NpZS5lZHUudHciLCJpc3MiOiJKV1QiLCJ1c2VyX2lkIjoiMjk5IiwibmJmIjoxNjQyMTU4MzMyLCJ2ZXIiOjAuMSwic2VydmljZV9pZCI6IjEwIiwiaWQiOjQyNywic2NvcGVzIjoiMCJ9.mQgZ36wk8_G77l54ycPdQKDcVTOVyBHL3IDPerKpqj0hFfYMBx7x6Skuh5oHm2F9EvSOZhTZ6Tupyz5ZpUyN32p3acusuI2DBiWCxLDvQQrOuAZnfH5m5atmK_lj-PMZkLSAAz1uVnHXIjJetwrya1WOZmG6-ZSFxKNsok8OhN8"
    result = ttc.process(token, data['text'])
    print(result)
    return result

if __name__ == "__main__":
    app.run(host="192.168.211.18", port="5000", debug=True)
