from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"

if __name__ == "__main__":
    # 0.0.0.0 binds to all interfaces; port 5000 is standard for local dev here
    app.run(host="0.0.0.0", port=5000)
