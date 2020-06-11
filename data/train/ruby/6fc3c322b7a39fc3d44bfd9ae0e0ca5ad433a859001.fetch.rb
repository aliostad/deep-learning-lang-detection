
require 'rest_client'
require 'fileutils'
require 'time'

#manCity => 11,
#blackBurn => 22,

tokens = { 
        :matchID => 3695871,
        :apiKey => 'xxxx',
        :startDate => 20140115,
        :endDate => 20140115,
        :competitionID => 300
    }

match = [
            'api/football/competition/matchDay/{apiKey}/{competitionID}/{startDate}',
            'api/football/match/actions/{apiKey}/{matchID}',
            'api/football/match/commentary/{apiKey}/{matchID}',
            'api/football/match/eaIndex/{apiKey}/{matchID}',
            'api/football/match/enhancedCommentary/{apiKey}/{matchID}',
            'api/football/match/events/{apiKey}/{matchID}',
            'api/football/match/fastevents/{apiKey}/{matchID}',
            'api/football/match/images/{apiKey}/{matchID}',
            'api/football/match/info/{apiKey}/{matchID}',
            'api/football/match/lineUps/{apiKey}/{matchID}',
            'api/football/match/mobileCommentary/{apiKey}/{matchID}',
            'api/football/match/postMatchStats/{apiKey}/{matchID}',
            'api/football/match/PreMatchPreview/{apiKey}/{matchID}',
            'api/football/match/preview/{apiKey}/{matchID}',
            'api/football/match/referee/{apiKey}/{matchID}/{startDate}/{endDate}',
            'api/football/match/report/{apiKey}/{matchID}',
            'api/football/match/stats/{apiKey}/{matchID}',
            'api/football/match/venue/{apiKey}/{matchID}'
        ]

# ---------------

def stash(url)
    
    FileUtils.mkdir_p url
    
    host = 'http://pads6.pa-sport.com/'
    
    RestClient.get(host + url) { |response, request, result|
    
    
        time = Time.now.utc.iso8601
        puts "%s %s %s" % [response.code, url, time]
        
        if (response.code == 200)
            File.open(url + "/" + time, 'w') { |f| f.write(response.body) }
        end
    }

end

match.each { |url|
    tokens.each { |key, value|
        url.gsub!(/{#{key}}/, value.to_s)
    }
    stash(url)
}
