# servidor_cubes.py
from flask import Flask
from flask_cors import CORS
from cubes.server import create_server
from configparser import ConfigParser

# Configuración INI
config_string = """
[workspace]
model = data/modelo.json

[store]
type = sql
url = sqlite:///data/ventas.db
schema = main

[server]
host = localhost
port = 5000
reload = no
log_level = info
allow_cors_origin = *
prettyprint = yes

[models]
main = data/modelo.json
"""

config = ConfigParser()
config.read_string(config_string)

app = create_server(config)

CORS(app, resources={r"/*": {"origins": "*", "methods": ["GET","POST","OPTIONS"], "allow_headers": ["Content-Type"]}})

@app.after_request
def after_request(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    return response

# --- BANDERA para imprimir ASCII solo una vez ---
ascii_printed = False

def print_ascii_once():
    global ascii_printed
    if not ascii_printed:
        ascii_art = """
⠀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣤⣤⣤⣤⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣠⡶⠿⠿⢛⣩⣭⣶⣶⣶⣶⣦⣭⣙⠿⣶⣤⣀⠀⠀⠀⠀
⠀⠀⠀⣾⠁⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠈⠛⠿⣷⡄⠀⠀
⠀⠀⢠⣿⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⣿⠀⠀
⠀⠀⢸⡟⣼⡿⢉⡉⢿⣿⡿⠿⠿⣿⣿⣿⠛⠛⣿⣧⠀⠀⣸⡿⠀⠀
⠀⠀⢸⡇⣿⡇⠘⠃⣸⠁⠀⠀⠀⠀⢹⡇⠸⠇⢸⣿⣷⠆⣿⡇⠀⠀
⠀⠀⠈⣿⡘⣿⢶⣶⡿⣦⣀⣀⣀⣠⣾⣷⣤⣤⢿⣿⣿⢰⡿⠁⠀⠀
⠀⠀⠀⠈⢷⣜⢿⣯⣿⣟⣡⣶⣌⠻⣿⣯⣿⣻⣿⡿⣡⣿⠁⠀⠀⠀
⠀⠀⠀⣀⣼⡇⢲⣈⣴⣶⡙⣿⡿⢋⣭⣉⣰⣶⣦⢰⣿⠁⠀⠀⠀⠀
⣠⡾⢟⣛⣋⣭⡤⢡⣿⣿⣧⣶⣦⡹⢛⣩⣴⣮⡉⢼⡏⠀⠀⠀⠀⠀
⢻⣦⡻⠿⢿⣿⢡⣿⠟⢋⣭⣭⠙⣰⣿⣿⠿⡋⢀⣾⣧⣤⣄⡀⠀⠀
⠀⠉⠻⠿⢷⡆⣿⡇⣾⢸⣿⡟⣴⣤⢠⣴⣶⣾⡌⠟⠋⠉⠙⠻⢷⣄
⠀⠀⠀⠀⢸⡇⢿⣿⣎⢘⣿⣇⠛⣫⣼⣿⣿⣿⠇⠀⠀⠀⠀⠀⣀⡿
⠀⠀⠀⠀⠘⢷⡘⢿⣿⣦⣬⣥⣵⣿⣿⣿⣿⠟⣀⣠⣤⣴⠶⠛⠉⠀
⠀⠀⠀⠀⢀⣼⠟⠂⠉⠛⠛⠿⠿⠿⠟⠛⠁⠘⢿⣿⡉⠀⠀⠀⠀⠀
⠀⠀⠀⢠⣿⡃⠀⠀⠀⢀⣾⡿⠿⢿⣧⠀⠀⠀⠀⢹⣷⠀⠀⠀⠀⠀
⠀⠀⠀⠈⠛⠿⠿⠿⠿⠟⠉⠀⠀⠈⠛⠿⠿⠿⠿⠿⠋⠀⠀⠀⠀⠀⠀⠀
"""
        print(ascii_art)
        print("="*60)
        print("- Servidor Cubes OLAP con CORS habilitado")
        print("="*60)
        print(f"- URL: http://localhost:5000")
        print(f"- Cubes: http://localhost:5000/cubes")
        print(f"- Info: http://localhost:5000/info")
        print(f"- Modelo: http://localhost:5000/cube/ventas/model")
        print(f"- Aggregate: http://localhost:5000/cube/ventas/aggregate")
        print("="*60)
        print("✅ CORS está habilitado - CubesViewer puede conectarse")
        print("="*60)
        print("\n⚠️  Presiona CTRL+C para detener el servidor\n")
        ascii_printed = True

if __name__ == "__main__":
    print_ascii_once()
    try:
        app.run(
            host='localhost',
            port=5000,
            debug=False,
            use_reloader=False,
            threaded=False
        )
    except KeyboardInterrupt:
        print("\n\n👋 Servidor detenido correctamente")
