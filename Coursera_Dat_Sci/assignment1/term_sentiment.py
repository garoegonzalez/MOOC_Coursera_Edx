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

def Extrapolate_score(word,scores):
    if word in scores.keys(): return scores[word]

        
def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])

    scores = load_score(sent_file)
    tweets = extract_tweets(tweet_file)
    dic_tweet_score = {}
    
    new_scores ={}

    ## We loop over all the tweets and we store their scores
    for tweet in tweets:
        for word in tweet.split(" "):
            if not word in scores.keys() and not word in new_scores.keys():
                new_scores[word]=tweet_score(scores,tweet)
            if word in new_scores.keys():
                new_scores[word]=float(new_scores[word]+tweet_score(scores,tweet))/2.

    ## Final output
    for tweet in tweets:
        for word in tweet.split(" "):
            if word in scores.keys(): print word.replace("\n",""), " ",scores[word]
            if word in new_scores.keys(): print word.replace("\n",""), " ",new_scores[word]

    sent_file.close()
    tweet_file.close()

if __name__ == '__main__':
    main()
