# RuuvitagRestGateway configuration
#
# All lines are required, DO NOT REMOVE ANY!
#

filtered_macs = []
#List of ruuvitag macs you want to listen and store in rest api
#Include macs in lowercase. Empty will ignore filter.
#Example: ['112233aabbcc',dd4455667788']

host_ip = "0.0.0.0"
#IP address of your hosting device, use "0.0.0.0" for access within the network, "localhost" for accessing from same device
#Example: "0.0.0.0" or "localhost"

host_port = 5000
#Port for accessing the api
#Example: 5000 or 80

use_debug_mode = False
#If you run into errors, setting this True will enable flask debug screens
