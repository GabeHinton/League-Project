import requests
import pandas
import numpy
import time
from pandas.io.json import json_normalize

# The JSON from request_summoner_number doesn't contain much information.  It will be primarily used to convert the
# summoner's name into their Riot ID number.

# BE SURE to enter your API Key in the appropriate blank within __main__!

def request_summoner_number(region, summoner_name, api_key):
    url = ("https://"+region+".api.pvp.net/api/lol/"+region+"/v1.4/summoner/by-name/"+summoner_name+
           "?api_key="+api_key)
    response = requests.get(url)
    return response.json()


# This huge JSON array will be a full match history of the player.  The only useful information we will extract
# are the match IDs, for now of the most recent 200 games.


def get_match_ids(region, summoner_number, api_key):
    url = ("https://"+region+".api.pvp.net/api/lol/"+region+"/v2.2/matchlist/by-summoner/"+summoner_number+
           "?api_key="+api_key)
    response = requests.get(url)
    return response.json()


# An even bigger JSON containing all the information for a given match.  We need to identify which number 1-10
# the summoner we're interested in was assigned, and then pull the corresponding data we want from them.


def get_match_json(match_id, region, api_key):
    url = ("https://"+region+".api.pvp.net/api/lol/"+region+"/v2.2/match/"+match_id+
           "?includeTimeline=true&api_key="+api_key)
    response = requests.get(url)
    return response.json()


def main():
    print "\nData Gathering Tool v0.1"
    print "Enter your region from the following list:"
    print "na euw eune lan br kr las oce tr ru pbe\n"

    # Be sure to put YOUR API_key in this blank before running the program.

    api_key = '6bd40045-3a0c-4f8e-9296-e6c3a76cf6a4'
    region = str(raw_input('Region (lower case):'))
    summoner_name = str(raw_input('Summoner Name IN LOWER CASE:'))

    # This request is to convert the summoner name to the summoner ID number.

    request1_json = request_summoner_number(region, summoner_name, api_key)
    print request1_json

    summoner_number = request1_json[summoner_name]['id']
    summoner_number = str(summoner_number)
    in_game_name = request1_json[summoner_name]['name']

    # This request is for the full match history.

    request2_json = get_match_ids(region, summoner_number, api_key)
    print request2_json

    match_id_list = json_normalize(request2_json['matches'])
    match_id_list = match_id_list['matchId']

    print match_id_list

    full_data = pandas.DataFrame()

    for n in xrange(0, 490):

        match_json = get_match_json(match_id=str(match_id_list[n]), region=region, api_key=api_key)
        print match_json

        # This is the draft for pulling the data I want out of the match JSON.

        for i in xrange(0, 9):
            if match_json['participantIdentities'][i]['player']['summonerName'] == in_game_name:
                match_participant_id = i+1

        new_data = pandas.DataFrame({'MatchID': match_id_list[n],
                                 'Winner?': [match_json['participants'][match_participant_id-1]['stats']['winner']],
                                 'Role': [match_json['participants'][match_participant_id-1]['timeline']['role']],
                                 'Lane': [match_json['participants'][match_participant_id-1]['timeline']['lane']],
                                 'Champion': [match_json['participants'][match_participant_id-1]['championId']],
                                 'Gold010': match_json['participants'][match_participant_id-1]
                                             ['timeline']['goldPerMinDeltas'].get('zeroToTen', numpy.nan),
                                 'Gold1020': match_json['participants'][match_participant_id-1]
                                              ['timeline']['goldPerMinDeltas'].get('tenToTwenty', numpy.nan),
                                 'Gold2030': match_json['participants'][match_participant_id-1]
                                              ['timeline']['goldPerMinDeltas'].get('twentyToThirty', numpy.nan),
                                 'Creeps010': match_json['participants'][match_participant_id-1]
                                               ['timeline']['creepsPerMinDeltas'].get('zeroToTen', numpy.nan),
                                 'Creeps1020': match_json['participants'][match_participant_id-1]
                                                ['timeline']['creepsPerMinDeltas'].get('tenToTwenty', numpy.nan),
                                 'Creeps2030': match_json['participants'][match_participant_id-1]
                                            ['timeline']['creepsPerMinDeltas'].get('twentyToThirty', numpy.nan),
                                 'DamageTaken010': match_json['participants'][match_participant_id-1]
                                            ['timeline']['damageTakenPerMinDeltas'].get('zeroToTen', numpy.nan),
                                 'DamageTaken1020': match_json['participants'][match_participant_id-1]
                                            ['timeline']['damageTakenPerMinDeltas'].get('tenToTwenty', numpy.nan),
                                 'DamageTaken2030': match_json['participants'][match_participant_id-1]
                                        ['timeline']['damageTakenPerMinDeltas'].get('twentyToThirty', numpy.nan),
                                 'SightWardsBought': [match_json['participants'][match_participant_id-1]['stats']
                                                      ['sightWardsBoughtInGame']],
                                 'VisionWardsBought': [match_json['participants'][match_participant_id-1]['stats']
                                                       ['visionWardsBoughtInGame']],
                                 'WardsPlaced': [match_json['participants'][match_participant_id-1]['stats']
                                                 ['wardsPlaced']],
                                 'WardsKilled': [match_json['participants'][match_participant_id-1]['stats']
                                                 ['wardsKilled']],
                                 'TotalTimeCCDealt': [match_json['participants'][match_participant_id-1]['stats']
                                                      ['totalTimeCrowdControlDealt']],
                                 'NeutralMinionsKilled': [match_json['participants'][match_participant_id-1]['stats']
                                                          ['neutralMinionsKilled']],
                                 'NeutralMinsTeamJungle': [match_json['participants'][match_participant_id-1]['stats']
                                                           ['neutralMinionsKilledTeamJungle']],
                                 'NeutralMinsEnemyJungle': [match_json['participants'][match_participant_id-1]['stats']
                                                            ['neutralMinionsKilledEnemyJungle']]})

        set_data = [full_data, new_data]

        full_data = pandas.concat(set_data)

        print full_data

        time.sleep(1.5) # So you won't go over your api_key rate limit


    full_data.to_csv('%s_history.csv' % summoner_name)

if __name__ == "__main__":
    main()
