import pandas as pd
from sklearn import ensemble
from sklearn.metrics import mean_absolute_error
from sklearn.externals import joblib
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
import numpy as np

# Load the data set
df = pd.read_csv("C:/Users/nikhil.deshmukh/Downloads/house_price.csv")

#Data cleaning and data preperation
del df['house_number']
del df['unit_number']
del df['street_name']
del df['zip_code']

#one hot encoding for features
features_df = pd.get_dummies(df, columns=['garage_type', 'city'])

del features_df['sale_price']

X = features_df.as_matrix()
y = df['sale_price'].as_matrix()

# Split the data set in a training set (70%) and a test set (30%)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
print X_train

model = ensemble.GradientBoostingRegressor()


param_grid = {
    'n_estimators': [500, 1000, 3000],
    'max_depth': [4, 6],
    'min_samples_leaf': [3, 5, 9, 17],
    'learning_rate': [0.1, 0.05, 0.02, 0.01],
    'max_features': [1.0, 0.3, 0.1],
    'loss': ['ls', 'lad', 'huber']
}
cv = GridSearchCV(model, param_grid, n_jobs=4)

# cross validation
cv.fit(X_train, y_train)
#It will show, which combination is the best fit
print(cv.best_params_)
mse = mean_absolute_error(y_train, cv.predict(X_train))
print("Training Set Mean Absolute Error: %.4f" % mse)

mse = mean_absolute_error(y_test, cv.predict(X_test))
print("Test Set Mean Absolute Error: %.4f" % mse)

#As the error is more we can still look for proper features to select
#feature Engineering#################
feature_labels = np.array(['year_built', 'stories', 'num_bedrooms', 'full_bathrooms', 'half_bathrooms', 'livable_sqft', 'total_sqft', 'garage_sqft', 'carport_sqft', 'has_fireplace', 'has_pool', 'has_central_heating', 'has_central_cooling', 'garage_type_attached', 'garage_type_detached', 'garage_type_none', 'city_Amystad', 'city_Brownport', 'city_Chadstad', 'city_Clarkberg', 'city_Coletown', 'city_Davidfort', 'city_Davidtown', 'city_East Amychester', 'city_East Janiceville', 'city_East Justin', 'city_East Lucas', 'city_Fosterberg', 'city_Hallfort', 'city_Jeffreyhaven', 'city_Jenniferberg', 'city_Joshuafurt', 'city_Julieberg', 'city_Justinport', 'city_Lake Carolyn', 'city_Lake Christinaport', 'city_Lake Dariusborough', 'city_Lake Jack', 'city_Lake Jennifer', 'city_Leahview', 'city_Lewishaven', 'city_Martinezfort', 'city_Morrisport', 'city_New Michele', 'city_New Robinton', 'city_North Erinville', 'city_Port Adamtown', 'city_Port Andrealand', 'city_Port Daniel', 'city_Port Jonathanborough', 'city_Richardport', 'city_Rickytown', 'city_Scottberg', 'city_South Anthony', 'city_South Stevenfurt', 'city_Toddshire', 'city_Wendybury', 'city_West Ann', 'city_West Brittanyview', 'city_West Gerald', 'city_West Gregoryview', 'city_West Lydia', 'city_West Terrence'])

model = joblib.load('C:/Users/nikhil.deshmukh/Downloads/trained_house.pkl')

importance = model.feature_importances_

feauture_indexes_by_importance = importance.argsort()

for index in feauture_indexes_by_importance:
    print("{} - {:.2f}%".format(feature_labels[index], (importance[index] * 100.0)))

    ''' Mosst imp features
    num_bedrooms - 4.57%
garage_sqft - 13.07%
year_built - 13.81%
livable_sqft - 17.09%
total_sqft - 17.61%
    '''

    '''Least import feature
    city_Martinezfort - 0.00%
city_Julieberg - 0.00%
city_New Michele - 0.00%
city_New Robinton - 0.00%
city_Rickytown - 0.05%
city_Davidtown - 0.06%
city_Fosterberg - 0.10%
city_Amystad - 0.12%
city_West Terrence - 0.13%
    '''
#After removing least important features we can again do the same process to remove the accuracy
