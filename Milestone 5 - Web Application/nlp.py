import re
import nltk
from nltk.stem import WordNetLemmatizer
from collections import Counter

class TextAnalyser:

    # stemming values
    NO_STEMMING = 0
    STEM = 1
    LEMMA = 2

    # Text object, with analysis methods
    def __init__(self, inputText, language="EN"):
        self.text = inputText
        self.tokens = []
        self.sentences = []
        self.language = language
        self.stopWords = set(open('stopwords'+ language +'.txt', 'r').read().splitlines())

    def length(self):  # results
        return len(self.text)

    def tokenise(self):  # preprocessText
        self.tokens = self.text.split()

    def tokeniseNLTK(self):
        self.tokens = nltk.word_tokenize(self.text)

    def getTokens(self):  # results
        return len(self.tokens)

    def splitSentences(self):  # preprocessText
        self.sentences = nltk.sent_tokenize(self.text)

    def getSentences(self):  # results
        return len(self.sentences)

    def removePunctuation(self):  # preprocessText
        self.text = re.sub(r'([^\s\w_]|_)+', '', self.text.strip())

    def removeStopWords(self):  # preprocessText
        self.tokens = [token for token in self.tokens if token not in self.stopWords]

    def lemmatiseVerbs(self):  # preprocessText
        lemmatizer = WordNetLemmatizer()
        return [lemmatizer.lemmatize(w,'v') for w in self.tokens]

    def stemTokens(self):  # preprocessText
        porter = nltk.PorterStemmer()
        return [porter.stem(t) for t in self.tokens]

    def preprocessText(self, lowercase=True, removeStopWords=False, stemming=NO_STEMMING):

        self.splitSentences()

        if lowercase:
            self.text = self.text.lower()

        self.removePunctuation()

        self.tokenise()

        if removeStopWords:
            self.removeStopWords()

        if stemming == TextAnalyser.STEM:
            self.tokens = self.stemTokens()
        elif stemming == TextAnalyser.LEMMA:
            self.tokens = self.lemmatiseVerbs()

    def uniqueTokens(self):  # results
        return (len(set(self.tokens)))

    def getMostCommonWords(self, n=10):  #  results
        wordsCount = Counter(self.tokens)
        return wordsCount.most_common()[:n]

