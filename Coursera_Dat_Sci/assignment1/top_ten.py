import sys
import json

def extract_tweets(tweet_file):
    '''Function which return a list of tweets given a raw tweet txt file. '''

    tweets = []
    for line in tweet_file.readlines():

        try:
            tweet     =json.loads(line)                
            tweet_text=tweet[u'text']
            tweets.append (tweet_text.replace("\n","")) 

        except KeyError:
            if tweet.has_key(u'delete') : pass

    return tweets

def extract_hashtag(tweet_file):
    '''Given a file of tweets the function extract all the hashtags and count them giving back a dictionary and the count ''' 
    dict_hashtag={}
    for line in tweet_file.readlines():
        try:
            tweet     =json.loads(line)
            for hashtag_temp in tweet[u'entities'][u'hashtags']: 
                if not hashtag_temp[u'text'] in dict_hashtag.keys(): dict_hashtag[hashtag_temp[u'text']]=1.
                else: dict_hashtag[hashtag_temp[u'text']]+=1.

        except KeyError:
            if tweet.has_key(u'delete') : pass

    return dict_hashtag


def main():

    tweet_file = open(sys.argv[1])
    dict_hashtag = {}

    dict_hashtag = extract_hashtag(tweet_file)
    tweet_file.close()
    
    ## We order order our and print the first 10
    counter=0
    for hashtag in sorted(dict_hashtag, key=dict_hashtag.get, reverse=True):
        print hashtag.replace("\n",""), " ",dict_hashtag[hashtag]
        counter+=1
        if counter==10: break


if __name__ == '__main__':
    main()
