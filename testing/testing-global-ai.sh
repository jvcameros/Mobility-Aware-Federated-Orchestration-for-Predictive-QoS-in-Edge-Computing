#!/bin/bash

#USER 1 194.199.113.180:30080 LUCAS
#USER 6 194.199.113.232:30090 CAR 
#USER 8 194.199.113.76:30085 JOE 

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}' |jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}' |jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}' |jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
#Now the predictor will have enough position logs to make a prediction which will be sent to the orchestrator
#Now the orchestrator will have predictions, so it will be able to find the closest edge server to the car, which hasn't logged his position till now 
#Note that in the first car position log, it won't access the service as the orchestrator hasn't received its position for placing the 
#service accordingly 
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"latitude":35.6425666809082,"longitude":139.57231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.58231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.59231567382812}'|jq
#------------------------
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4633759,"longitude":0.4012383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46392548,"longitude":0.35994177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.60231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4634759,"longitude":0.4013383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45992548,"longitude":0.36294177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.61231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4635759,"longitude":0.4014383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45642548,"longitude":0.36444177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.62231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4636759,"longitude":0.4015383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45292548,"longitude":0.36694177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.63231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4637759,"longitude":0.4016383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.44942548,"longitude":0.36944177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.64231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4638759,"longitude":0.4017383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.44592548,"longitude":0.37194177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.65231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4639759,"longitude":0.4018383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.44242548,"longitude":0.37444177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.66231567382812}'|jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4640759,"longitude":0.4019383}' |jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.43892548,"longitude":0.37694177}' |jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.67231567382812}'|jq