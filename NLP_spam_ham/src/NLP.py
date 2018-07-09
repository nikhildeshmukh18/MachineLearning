import pandas as pd
import string
import re
import nltk
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import KFold, cross_val_score
from sklearn.ensemble import RandomForestClassifier
import numpy as np


data = pd.read_csv('C:/Users/nikhil.deshmukh/PycharmProjects/deep_learning/NLP/spamham.tsv', sep='\t',header=None)
print(data[0:500])
data.columns=['label', 'mail']

data.loc[data['label'] == 'spam']
data.loc[data['label'] == 'ham']


data.loc[data['label'].isnull().sum()]
data.loc[data['mail'].isnull().sum()]

####################DATA CLEANING###############################

#cleaning punctuations

def remove_punct(text):
    text_nopunct = "".join([char for char in text if char not in string.punctuation])
    return text_nopunct

data['cleaned_mail'] = data['mail'].apply(lambda x: remove_punct(x))

data.head()

#Tokenization

def tokenization(text):
    tokens = re.split('\W',text)
    return tokens

data['tokenized_mail'] = data['cleaned_mail'].apply(lambda x: tokenization(x.lower()))
    
data.head()

#remove stop words (the to etc)

stopwords = nltk.corpus.stopwords.words('english')
stopwords.head()

def remove_stopwords(text): 
    text_wtstop = [word for word in text if word not in stopwords]
    return text_wtstop
data['wt_stopwords'] = data['tokenized_mail'].apply(lambda x: remove_stopwords(x))

data.head()

'''
#stemming
ps = nltk.PorterStemmer()
def stemming(tokenized_text):
    text = [ps.stem(word) for word in tokenized_text]
    return text
data['stemmed_mail'] = data['wt_stopwords'].apply(lambda x: stemming(x))
data.head()
'''

#lemmatizing
ws = nltk.WordNetLemmatizer()
def lemma(tokenized_text):
    text = [ws.lemmatize(word) for word in tokenized_text]
    return text
data['lemmatized_mail'] = data['wt_stopwords'].apply(lambda x: lemma(x))
data.head()

#count vectorize
count_vect = CountVectorizer(analyzer= lemma)
x_count = count_vect.fit_transform(data['lemmatized_mail'])
print(x_count.shape)
print(count_vect.get_feature_names())

#sparse matrix to arrays
x_counts  = pd.DataFrame(x_count.toarray())
print(x_counts)
#assign column names
x_counts.head()

####################MODELING Random forest with cros val############################################################################
RandomForestClassifier()
rf = RandomForestClassifier(n_jobs=-1)
k_fold = KFold(n_splits=5)
score = cross_val_score(rf, x_counts, data['label'], cv=k_fold, scoring='accuracy', n_jobs=-1)

np.average(score) #Averafe (after cross val ) accuracy = 96.4%
    

from sklearn.metrics import precision_recall_fscore_support as score
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

X_train, X_test, y_train, y_test = train_test_split(x_counts, data['label'], test_size = 0.2)
rf = RandomForestClassifier(n_estimators=50, max_depth=20, n_jobs=-1)
rf_model = rf.fit(X_train, y_train)

#importance feature Engineering
sorted(zip(rf_model.feature_importances_, X_train.columns), reverse=True)[0:10]
# claim, call, free, service, mobile,txt
y_pred = rf_model.predict(X_test)
precision, recall, fscore, support = score(y_test, y_pred, pos_label='spam', average='binary')

print('Precision: {} / Recall: {} / Accuracy: {}'.format(round(precision, 3),
                                                        round(recall, 3),
                                                        round((y_pred==y_test).sum() / len(y_pred),3)))

#Precision: 1.0 / Recall: 0.615 / Accuracy: 0.949

################  K-nearest#########################################################
from sklearn import neighbors, datasets

knn=neighbors.KNeighborsClassifier(n_neighbors = 29)

new_data= x_counts[['claim', 'call', 'free', 'service', 'mobile','txt']]
new_data= x_counts.iloc[:, 0:6]

X_train, X_test, y_train, y_test = train_test_split(new_data, data['label'], test_size = 0.2)

knn_model = knn.fit(X_train, y_train)
y_pred = knn.predict(X_test)

print('Precision: {} / Recall: {} / Accuracy: {}'.format(round(precision, 3),
                                                        round(recall, 3),
                                                        round((y_pred==y_test).sum() / len(y_pred),3)))

###Precision: 1.0 / Recall: 0.615 / Accuracy: 0.925