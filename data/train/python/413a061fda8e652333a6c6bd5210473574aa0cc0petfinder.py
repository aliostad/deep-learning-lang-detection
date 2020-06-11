"""
This module takes the petfinder API and makes it python friendly.
""""
import pprint
import requests
import config

API_BASE = "http://api.petfinder.com/"
API_gettoken = API_BASE + "auth.getToken"

API_getRandomPet = API_BASE + "pet.getRandom"
API_getPet = API_BASE + "pet.get"
API_findPet = API_BASE + "pet.find"

API_findShelter = API_BASE + "shelter.find"
API_getShelter = API_BASE + "shelter.get"
API_getSheleterPet = API_BASE + "shelter.get"
API_getAllShelterPets = API_BASE + "shelter.getPets"
API_getShleterBreeds = API_BASE + "shelter.listByBreed"


def getRandom_params(location):

    params = dict()
    params["key"] = config.key
    params["location"] = location
    params["format"] = "json"

    return params

def get_params(petid):
    params = dict()
    params["key"] = config.key
    params['id'] = petid
    params['format'] = "json"
    return params

def queryAPI(API_URL, params):

    request = requests.get(API_URL, params = params)
    data = request.json()

    return data
