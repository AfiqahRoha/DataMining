import pandas as pd
from flask import Flask, render_template, request
from forms import InputTextForm
from nlp import TextAnalyser
from nltk.sentiment.vader import SentimentIntensityAnalyzer

app = Flask(__name__)
app.config.from_object('config')

# Submit button in web for pressed
@app.route('/', methods=['POST'])
@app.route('/index', methods=['POST'])
def manageRequest():

    # initialisation
    theInputForm = InputTextForm()
    userText = "and not leave this empty!"
    typeText = "You should write something ..."
    language = "EN"

    # POST - retrieve all user submitted data
    if theInputForm.validate_on_submit():
        userText = theInputForm.inputText.data
        typeText = "Your own text"
        language = request.form['lang']

    stemmingEnabled = request.form.get("stemming")

    if stemmingEnabled:
        if request.form.get("engine"):
            stemmingType = TextAnalyser.STEM
        else:
            stemmingType = TextAnalyser.LEMMA
    else:
        stemmingType = TextAnalyser.NO_STEMMING

    if 'TA' in request.form.values():

        # Text Analysis
        myText = TextAnalyser(userText, language) # new object

        myText.preprocessText(lowercase = theInputForm.ignoreCase.data,
                              removeStopWords = theInputForm.ignoreStopWords.data,
                              stemming = stemmingType)

        # display all user text if short otherwise the first fragment of it
        if len(userText) > 99:
            fragment = userText[:99] + " ..."
        else:
            fragment = userText

        # check that there is at least one unique token to avoid division by 0
        if myText.uniqueTokens() == 0:
            uniqueTokensText = 1
        else:
            uniqueTokensText = myText.uniqueTokens()

        return render_template('results.html',
                               title='Text Analysis',
                               inputTypeText=typeText,
                               originalText=fragment,
                               numChars = myText.length(),
                               numSentences = myText.getSentences(),
                               numTokens = myText.getTokens(),
                               uniqueTokens = uniqueTokensText,
                               commonWords = myText.getMostCommonWords(10))

    else:
        analyzer = SentimentIntensityAnalyzer()
        scores = analyzer.polarity_scores(userText)
        if scores['compound'] > 0:
            sentiment='Positive'
        elif scores['compound']< 0:
            sentiment='Negative'
        else:
            sentiment='Neutral'

        return render_template('sentiment.html',
                               title='Text Analysis',
                               sentiment_scores = scores,
                               sentiment=sentiment)

# the initial main page
@app.route('/', methods=['GET'])
@app.route('/index', methods=['GET'])
def initial():
    return render_template('index.html',
                           title = 'Sentiment Analyzer',
                           form = InputTextForm())

# the about page
@app.route('/about')
def model():

    dfm1 = pd.read_csv('cm_lr.csv')
    dfm1.set_index(['Unnamed: 0'], inplace=True)
    dfm1.index.name = None
    dfm2 = pd.read_csv('cm_rf.csv')
    dfm2.set_index(['Unnamed: 0'], inplace=True)
    dfm2.index.name = None
    dfm3 = pd.read_csv('cm_nb.csv')
    dfm3.set_index(['Unnamed: 0'], inplace=True)
    dfm3.index.name = None
    dfm4 = pd.read_csv('cm_svm.csv')
    dfm4.set_index(['Unnamed: 0'], inplace=True)
    dfm4.index.name = None
    dfm5 = pd.read_csv('cm_xgb.csv')
    dfm5.set_index(['Unnamed: 0'], inplace=True)
    dfm5.index.name = None

    dfc1 = pd.read_csv('cr_lr.csv')
    dfc1.set_index(['Unnamed: 0'], inplace=True)
    dfc1.index.name = None
    dfc2 = pd.read_csv('cr_rf.csv')
    dfc2.set_index(['Unnamed: 0'], inplace=True)
    dfc2.index.name = None
    dfc3 = pd.read_csv('cr_nb.csv')
    dfc3.set_index(['Unnamed: 0'], inplace=True)
    dfc3.index.name = None
    dfc4 = pd.read_csv('cr_svm.csv')
    dfc4.set_index(['Unnamed: 0'], inplace=True)
    dfc4.index.name = None
    dfc5 = pd.read_csv('cr_xgb.csv')
    dfc5.set_index(['Unnamed: 0'], inplace=True)
    dfc5.index.name = None

    return render_template('about.html', title='Model',
                           tables1 = [dfm1.to_html(classes='confusion'),
                                      dfm2.to_html(classes='confusion'),
                                      dfm3.to_html(classes='confusion'),
                                      dfm4.to_html(classes='confusion'),
                                      dfm5.to_html(classes='confusion')],
                           tables2 = [dfc1.to_html(classes='classification'),
                                      dfc2.to_html(classes='classification'),
                                      dfc3.to_html(classes='classification'),
                                      dfc4.to_html(classes='classification'),
                                      dfc5.to_html(classes='classification')],
                           titles1 = ['na',
                                     'Logistic Regression',
                                     'Random Forest',
                                     'Naive Bayes',
                                     'Support Vector',
                                     'XGBoost'],
                           titles2 = ['na',
                                     'Logistic Regression',
                                     'Random Forest',
                                     'Naive Bayes',
                                     'Support Vector',
                                     'XGBoost'])

if __name__ == "__main__":
    app.run(debug=True)