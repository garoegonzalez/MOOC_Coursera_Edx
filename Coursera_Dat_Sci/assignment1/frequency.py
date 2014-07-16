import sys
import json

def load_score(sent_file):
    '''Function which store in a dictiory the word-score which comes from an external file'''
    scores = {} # initialize an empty dictionary
    for line in sent_file.readlines():
        term, score  = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
        scores[term] = int(score)        # Convert the score to an integer.
    #print scores.items() # Print every (term, score) pair in the dictionary
    return scores

def extract_tweets(tweet_file):
    '''Function which return a list of tweets given a raw tweet txt file. '''

    tweets = []
    for line in tweet_file.readlines():

        try:
            tweet     =json.loads(line)
            tweet_text=tweet[u'text']
            tweets.append (tweet_text) 

        except KeyError:
            if tweet.has_key(u'delete') : pass

    return tweets

def tweet_score(scores,tweet):
    '''Function which given a dictionary of scores per words and a tweet gives the score of the tweet'''
    score=0
    for word in tweet.split(" "):
        score+=scores.get(word,0)
    
    return score

def list_words_number(tweets):
    '''This function return a list of words which appear in the tweets. Not adding the ones which are repeated '''
    dict_wordfrec={}
    total_words=0.
    for tweet in tweets:
        for word in tweet.split(" "):
            if not word in dict_wordfrec.keys(): dict_wordfrec[word]=1.
            else: dict_wordfrec[word]+=1.
            total_words+=1.
    return dict_wordfrec,total_words

def main():

    tweet_file = open(sys.argv[1])
    tweets = extract_tweets(tweet_file)

    ## We loop over all the tweets and get their scores
    dict_wordfre={}
    total_words=0.
    dict_wordfrec,total_words = list_words_number(tweets)
    
    for word in dict_wordfrec.keys(): 
        #if '\\u' in word: continue
        unicode_string = word
        encoded_string = word.encode('utf-8')
        print word.replace("\n",""), " ", dict_wordfrec[word]/total_words

    tweet_file.close()

if __name__ == '__main__':
    main()
