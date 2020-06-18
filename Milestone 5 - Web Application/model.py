import os
import pandas as pd
from nltk.corpus import stopwords
from nltk.stem.porter import *
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn import svm
from xgboost import XGBClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report

os.getcwd()
os.chdir('C:\\Users\\User\\PycharmProjects\\flaskmethod15')

#reddit dataset
reddit = pd.read_csv('reddit_sentiments.csv', encoding='utf-8-sig')
#comments under reddit post dataset
comments = pd.read_csv('comments_sentiments.csv', encoding='utf-8-sig')
#twitter dataset
twitter = pd.read_csv('twitter_sentiments.csv', encoding='utf-8-sig')

#merge all the text and sentiments columns
df1 = reddit[['SUBREDDIT', 'TEXT', 'SENTIMENTS']]
df1.columns = ['MODEL', 'TEXT', 'SENTIMENTS']
df2 = comments[['SUBREDDIT', 'NEW_COMMENTS', 'SENTIMENTS']]
df2.columns = ['MODEL', 'TEXT', 'SENTIMENTS']
df3 = twitter[['MODEL', 'NEW_TEXT', 'SENTIMENTS']]
df3.columns = ['MODEL', 'TEXT', 'SENTIMENTS']
text_df = pd.concat([df1,df2,df3])

#feature selection
features = text_df.iloc[:, 1].values
labels = text_df.iloc[:, 2].values

# simple data cleaning
stop_words = stopwords.words('english')

def remove_noise(features, stop_words):
    processed_features = []

    for sentence in range(0, len(features)):
        # Remove all the special characters
        processed_feature = re.sub(r'\W', ' ', str(features[sentence]))

        # Remove numbers
        processed_feature = re.sub(r'[0-9]+', ' ', processed_feature)

        # Remove all single characters
        processed_feature = re.sub(r'\s+[a-zA-Z]\s+', ' ', processed_feature)

        # Remove single characters from the start
        processed_feature = re.sub(r'\^[a-zA-Z]\s+', ' ', processed_feature)

        # Substituting multiple spaces with single space
        processed_feature = re.sub(r'\s+', ' ', processed_feature)

        # Removing prefixed 'b'
        processed_feature = re.sub(r'^b\s+', '', processed_feature)

        # Converting to Lowercase
        processed_feature = processed_feature.lower()

        # Removing stopwords
        processed_feature = ' '.join([word for word in processed_feature.split() if word not in stop_words])

        processed_features.append(processed_feature)

    return processed_features

processed_features = remove_noise(features, stop_words)
processed_features = pd.DataFrame(processed_features)
processed_features.columns = ['TEXT']

#tokenizing
tokenized_features = processed_features['TEXT'].apply(lambda x: x.split())

#stemming
stemmer = PorterStemmer()
tokenized_features = tokenized_features.apply(lambda x: [stemmer.stem(i) for i in x])
# stitch the tokens back together
for i in range(len(tokenized_features)):
    tokenized_features[i] = ' '.join(tokenized_features[i])

processed_features['TEXT'] = tokenized_features

#Term Frequency and Inverse Document Frequency(TF-IDF)
tfidf_vectorizer = TfidfVectorizer(max_features=1000, min_df=2, max_df=0.9, stop_words='english')
processed_features = tfidf_vectorizer.fit_transform(processed_features['TEXT'])

#splitting training and testing set
X_train, X_test, y_train, y_test = train_test_split(processed_features[:44546,:], labels, test_size=0.3, random_state=42)

#Building the model
"""These are the list of algorithms used for modeling text classifier:
1. Logistic Regression
2. Random Forest
3. Gaussian Naive Bayes
4. Support Vector Machine
5. XGBoost"""

#Logistic Regression
log_reg = LogisticRegression()
log_reg.fit(X_train, y_train)
predictions_lr = log_reg.predict(X_test)
acc_lr = round(accuracy_score(y_test, predictions_lr) * 100, 2)
fsc_lr = round(f1_score(y_test, predictions_lr, average='macro') * 100, 2)

#Random Forest
text_classifier = RandomForestClassifier(n_estimators=400, random_state=11)
text_classifier.fit(X_train, y_train)
predictions_rf = text_classifier.predict(X_test)
acc_rf = round(accuracy_score(y_test, predictions_rf) * 100, 2)
fsc_rf = round(f1_score(y_test, predictions_rf, average='macro') * 100, 2)

#Gaussian Naive Bayes
model = GaussianNB()
model.fit(X_train.toarray(), y_train)
predictions_nb = model.predict(X_test.toarray())
acc_nb = round(accuracy_score(y_test, predictions_nb) * 100, 2)
fsc_nb = round(f1_score(y_test, predictions_nb, average='macro') * 100, 2)

#Support Vector Machine
svc = svm.SVC(kernel='linear', C=1, probability=True)
svc.fit(X_train, y_train)
predictions_svm = svc.predict(X_test)
acc_svm = round(accuracy_score(y_test, predictions_svm) * 100, 2)
fsc_svm = round(f1_score(y_test, predictions_svm, average='macro') * 100, 2)

#XGBoost
xgb = XGBClassifier(max_depth=6, n_estimators=1000)
xgb.fit(X_train, y_train)
predictions_xgb = xgb.predict(X_test)
acc_xgb = round(accuracy_score(y_test, predictions_xgb) * 100, 2)
fsc_xgb = round(f1_score(y_test, predictions_xgb, average='macro') * 100, 2)

#comparison of the models
models = pd.DataFrame({
    'Model': ['Logistic Regression', 'Random Forest', 'Gaussian Naive Bayes', 'Support Vector Machine', 'XGBoost'],
    'Accuracy Score': [acc_lr, acc_rf, acc_nb, acc_svm, acc_xgb],
    'F1-Score': [fsc_lr, fsc_rf, fsc_nb, fsc_svm, fsc_xgb]})

#evaluating model
#confusion matrix
matrix_lr = confusion_matrix(y_test, predictions_lr)
matrix_rf = confusion_matrix(y_test, predictions_rf)
matrix_nb = confusion_matrix(y_test, predictions_nb)
matrix_svm = confusion_matrix(y_test, predictions_svm)
matrix_xgb = confusion_matrix(y_test, predictions_xgb)

dfm1 = pd.DataFrame(matrix_lr, columns=["Negatives", "Neutrals", "Positives"],
                    index=["Negatives", "Neutrals", "Positives"])
dfm2 = pd.DataFrame(matrix_rf, columns=["Negatives", "Neutrals", "Positives"],
                    index=["Negatives", "Neutrals", "Positives"])
dfm3 = pd.DataFrame(matrix_nb, columns=["Negatives", "Neutrals", "Positives"],
                    index=["Negatives", "Neutrals", "Positives"])
dfm4 = pd.DataFrame(matrix_svm, columns=["Negatives", "Neutrals", "Positives"],
                    index=["Negatives", "Neutrals", "Positives"])
dfm5 = pd.DataFrame(matrix_xgb, columns=["Negatives", "Neutrals", "Positives"],
                    index=["Negatives", "Neutrals", "Positives"])

dfm1.to_csv('cm_lr.csv', index=True, header=True)
dfm2.to_csv('cm_rf.csv', index=True, header=True)
dfm3.to_csv('cm_nb.csv', index=True, header=True)
dfm4.to_csv('cm_svm.csv', index=True, header=True)
dfm5.to_csv('cm_xgb.csv', index=True, header=True)

#classification report
report_lr = classification_report(y_test, predictions_lr, output_dict=True)
report_rf = classification_report(y_test, predictions_rf, output_dict=True)
report_nb = classification_report(y_test, predictions_nb, output_dict=True)
report_svm = classification_report(y_test, predictions_svm, output_dict=True)
report_xgb = classification_report(y_test, predictions_xgb, output_dict=True)

dfc1 = pd.DataFrame(report_lr).transpose()
dfc2 = pd.DataFrame(report_rf).transpose()
dfc3 = pd.DataFrame(report_nb).transpose()
dfc4 = pd.DataFrame(report_svm).transpose()
dfc5 = pd.DataFrame(report_xgb).transpose()

dfc1.to_csv('cr_lr.csv', index=True, header=True)
dfc2.to_csv('cr_rf.csv', index=True, header=True)
dfc3.to_csv('cr_nb.csv', index=True, header=True)
dfc4.to_csv('cr_svm.csv', index=True, header=True)
dfc5.to_csv('cr_xgb.csv', index=True, header=True)

