{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf100
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 import flightradar24\
fr = flightradar24.Api()\
\
# Airports\
airports = fr.get_airports()\
airport_codes = []\
for airport in airports['rows']:\
    airport_codes.append(airport['iata'])\
airport_codes.sort()\
\
# Airlines\
airlines = fr.get_airlines()\
airline_codes = []\
for airline in airlines['rows']:\
    airline_codes.append(airline['ICAO'])\
\
# Flights\
flights = \{\}\
for code in airline_codes:\
    current_flights = fr.get_flights(code)\
    flights.update(current_flights)\
\
# Remove junk from dict\
for key in ['full_count', 'stats', 'version']:\
    flights.pop(key)\
\
# Create link between airports\
departures = []\
arrivals = []\
for key, value in flights.items():\
        departures.append(value[11])\
        arrivals.append(value[12])\
\
# Remove empty values\
i = 0\
while i < len(departures):\
    if arrivals[i]  == '' or departures[i] == '':\
        departures.pop(i)\
        arrivals.pop(i)\
    else: \
        i = i + 1\
print(i) # Numeber of link\
\
# Substitute nodes's name with number\
i = 0\
while i < len(airport_codes):\
    for j in range(len(departures)):\
        if departures[j] == airport_codes[i]:\
            departures[j] = i\
    for k in range(len(arrivals)):\
        if arrivals[k] == airport_codes[i]:\
            arrivals[k] = i\
    i = i + 1\
\
# Find string (problem with list of airport not complete)\
num_airports = len(airport_codes)\
for i in range(0, len(departures)):\
    if type(departures[i])!= int:\
        airport_codes.append(departures[i])\
        departures[i] = num_airports\
        num_airports = num_airports + 1\
    if type(arrivals[i]) != int:\
        airport_codes.append(arrivals[i])\
        arrivals[i] = num_airports\
        num_airports = num_airports + 1\
\
# Print in airport_list.txt the name of the nodes    \
for i in range(len(airport_codes)):\
    print(i, ':' , airport_codes[i], file=open("airport_list.txt", "a"))\
\
print(len(airport_codes)) # Number of nodes\
\
# Print dataset in Dataset.txt\
for i in range(len(departures)):\
    print('\{0\}\\t\{1\}'.format(departures[i], arrivals[i]), file=open("Dataset.txt", "a"))\
    #print(departures[i], arrivals[i], file=open("Dataset.txt", "a")\
\
# Find biggest hub\
from collections import Counter\
import operator\
\
dep = Counter(departures)\
sorted_dep = sorted(dep.items(), key=operator.itemgetter(1))\
print('Occurences departures:', sorted_dep)\
\
print('\\n')\
\
arr = Counter(arrivals)\
sorted_arr = sorted(arr.items(), key=operator.itemgetter(1))\
print('Occurences arrivals:', sorted_arr)\
\
}