from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    name = request.form['name']
    email = request.form['email']
    save_data(name, email)
    return render_template('submit.html', name=name, email=email)


def save_data(name, email):
    with open('files/data.txt', 'a') as f:
        f.write(f'{name}, {email}\n')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)