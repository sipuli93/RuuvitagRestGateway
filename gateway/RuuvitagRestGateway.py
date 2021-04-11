from flask import Flask, request
from flask_restful import Resource, Api, abort
from ruuvitag_sensor.ruuvi import RuuviTagSensor
from threading import Thread
from datetime import datetime, timezone

app = Flask(__name__)
api = Api(app)

macs = [] #empty = don't filter
saved_ruuvitags = {}

def abort_if_mac_doesnt_exist(ruuvitag_mac):
    if ruuvitag_mac not in saved_ruuvitags:
        abort(404, message="Ruuvitag with mac {} doesn't exist".format(ruuvitag_mac))

class ruuvitags(Resource):
    def get(self, ruuvitag_mac):
        abort_if_mac_doesnt_exist(ruuvitag_mac)
        return {"ruuvitags": [saved_ruuvitags[ruuvitag_mac]]}

class ruuvitags_all(Resource):
    def get(self):
        response = {"ruuvitags":[]}
        for ruuvitag in saved_ruuvitags:
            response["ruuvitags"].append(saved_ruuvitags[ruuvitag])
        return response

api.add_resource(ruuvitags, '/ruuvitag/<string:ruuvitag_mac>')
api.add_resource(ruuvitags_all, '/')

#define callback function that saves found data
def save_scan(received_data):
    mac = received_data[1]['mac']
    ruuvi_data = received_data[1]
    ruuvi_data['broadcasted'] = datetime.now(timezone.utc).astimezone().isoformat()
    saved_ruuvitags[mac] = ruuvi_data

#define and start worker in daemon mode
def worker():
    RuuviTagSensor.get_datas(save_scan, macs)

thread = Thread(target=worker)
thread.daemon = True
thread.start()

if __name__ == '__main__':
    app.run(debug=False,host='0.0.0.0')
