import sys
import json
 
states = {
        'AK': 'Alaska',
        'AL': 'Alabama',
        'AR': 'Arkansas',
        'AS': 'American Samoa',
        'AZ': 'Arizona',
        'CA': 'California',
        'CO': 'Colorado',
        'CT': 'Connecticut',
        'DC': 'District of Columbia',
        'DE': 'Delaware',
        'FL': 'Florida',
        'GA': 'Georgia',
        'GU': 'Guam',
        'HI': 'Hawaii',
        'IA': 'Iowa',
        'ID': 'Idaho',
        'IL': 'Illinois',
        'IN': 'Indiana',
        'KS': 'Kansas',
        'KY': 'Kentucky',
        'LA': 'Louisiana',
        'MA': 'Massachusetts',
        'MD': 'Maryland',
        'ME': 'Maine',
        'MI': 'Michigan',
        'MN': 'Minnesota',
        'MO': 'Missouri',
        'MP': 'Northern Mariana Islands',
        'MS': 'Mississippi',
        'MT': 'Montana',
        'NA': 'National',
        'NC': 'North Carolina',
        'ND': 'North Dakota',
        'NE': 'Nebraska',
        'NH': 'New Hampshire',
        'NJ': 'New Jersey',
        'NM': 'New Mexico',
        'NV': 'Nevada',
        'NY': 'New York',
        'OH': 'Ohio',
        'OK': 'Oklahoma',
        'OR': 'Oregon',
        'PA': 'Pennsylvania',
        'PR': 'Puerto Rico',
        'RI': 'Rhode Island',
        'SC': 'South Carolina',
        'SD': 'South Dakota',
        'TN': 'Tennessee',
        'TX': 'Texas',
        'UT': 'Utah',
        'VA': 'Virginia',
        'VI': 'Virgin Islands',
        'VT': 'Vermont',
        'WA': 'Washington',
        'WI': 'Wisconsin',
        'WV': 'West Virginia',
        'WY': 'Wyoming'
        }

def load_score(sent_file):
    '''Function which store in a dictiory the word-score which comes from an external file'''
    scores = {} # initialize an empty dictionary
    for line in sent_file.readlines():
        term, score  = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
        scores[term] = int(score)        # Convert the score to an integer.
    return scores

def extract_tweets(tweet_file):
    '''Function which return a list of tweets given a raw tweet txt file. '''

    tweets = []
    for line in tweet_file.readlines():

        try:
            tweet     =json.loads(line)
            if tweet[u'lang']== "en" and not tweet[u'place']==None :
                if tweet[u'place'][u'country_code'] == u'US':
                    tweets.append (tweet)

        except KeyError:
            if tweet.has_key(u'delete') : pass

    return tweets

def tweet_score(scores,tweet):
    '''Function which given a dictionary of scores per words and a tweet gives the score of the tweet'''
    score=0
    for word in tweet.split(" "):
        score+=scores.get(word,0)
    
    return score

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])

    scores = load_score(sent_file)
    tweets = extract_tweets(tweet_file)
    state_scores={}

    for state in states.keys():
        state_scores[state]=0.

    for tweet in  tweets: 
        for ab,full in states.items():
            if ab in tweet[u"place"][u'full_name'] or full in tweet[u"place"][u'full_name']: 
                state_scores[ab]=(tweet_score(scores,tweet[u'text'])+state_scores[ab])/2.

    counter=0
    for state in sorted(state_scores, key=state_scores.get, reverse=True):
        print state
        break
    
    sent_file.close()
    tweet_file.close()

if __name__ == '__main__':
    main()
