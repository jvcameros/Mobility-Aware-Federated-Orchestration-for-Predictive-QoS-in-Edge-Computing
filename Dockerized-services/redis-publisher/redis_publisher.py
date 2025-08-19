import redis
import random
import time
import os

redis_host = os.getenv("REDIS_HOST", "localhost")
redis_port = 6379
input = []

i=1

r = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)

def simulate_temperature():
    return round(random.uniform(20, 30), 2)

while True:
    my_speed = simulate_temperature()
    # t1 = time.time()
    r.set("speed limitation",str(my_speed))
    r.set("occupation", random.randint(40,90))
    r.set("intersection", "free")
    r.set("crosswalk","free")
    print("Data Base status:")
    if i%10==0:
        r.set("zone_2","person")
    else:
        r.set("zone_2","nothing")

    if i%11==0:
        r.set("detected","light")
    else:
        r.set("ligt","nothing")
    i+=1
    keys = r.keys("*")
    for item in keys:
        print(item, r.get(item))
    time.sleep(5)
    print("\n")
    # input.append(t1)
