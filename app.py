from flask import Flask, request, jsonify

app = Flask(__name__)

def parse_ab():
    """Pulls a and b from query params or JSON, validates them, returns (a, b) or an error response."""
    # Accept both ?a=&b= and JSON {"a":..,"b":..}
    a = request.args.get("a")
    b = request.args.get("b")

    if a is None or b is None:
        if request.is_json:
            body = request.get_json(silent=True) or {}
            a = body.get("a", a)
            b = body.get("b", b)

    # Validate presence
    if a is None or b is None:
        return None, None, jsonify({"error": "Missing 'a' or 'b'."}), 400

    # Validate numeric
    try:
        a = float(a)
        b = float(b)
    except (TypeError, ValueError):
        return None, None, jsonify({"error": "'a' and 'b' must be numbers."}), 400

    return a, b, None, None

@app.get("/health")
def health():
    return jsonify({"status": "healthy"})

@app.get("/add")
def add():
    a, b, err, code = parse_ab()
    if err: return err, code
    return jsonify({"operation": "add", "a": a, "b": b, "result": a + b})

@app.get("/subtract")
def subtract():
    a, b, err, code = parse_ab()
    if err: return err, code
    return jsonify({"operation": "subtract", "a": a, "b": b, "result": a - b})

@app.get("/multiply")
def multiply():
    a, b, err, code = parse_ab()
    if err: return err, code
    return jsonify({"operation": "multiply", "a": a, "b": b, "result": a * b})

@app.get("/divide")
def divide():
    a, b, err, code = parse_ab()
    if err: return err, code
    if b == 0:
        return jsonify({"error": "Division by zero."}), 400
    return jsonify({"operation": "divide", "a": a, "b": b, "result": a / b})

# Optional index
@app.get("/")
def index():
    return jsonify({
        "endpoints": {
            "/add?a=&b=": "GET",
            "/subtract?a=&b=": "GET",
            "/multiply?a=&b=": "GET",
            "/divide?a=&b=": "GET",
            "/health": "GET"
        }
    })

if __name__ == "__main__":
    # 0.0.0.0 so Docker can expose it later
    app.run(host="0.0.0.0", port=5000, debug=True)
