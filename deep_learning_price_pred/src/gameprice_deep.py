from sklearn.preprocessing import MinMaxScaler
import pandas as pd
from keras.models import Sequential
from keras.layers import Dense

train_data = pd.read_csv('C:/Users/nikhil/deep_learning/keras/sales_data_train.csv')
test_data = pd.read_csv('C:/Users/nikhil/deep_learning/keras/sales_data_test.csv')

scale = MinMaxScaler(feature_range=(0,1))
scaled_train = scale.fit_transform(train_data)
scaled_test = scale.transform(test_data)

scaled_train_df = pd.DataFrame(scaled_train, columns = train_data.columns.values)
scaled_test_df = pd.DataFrame(scaled_test, columns = test_data.columns.values)

scaled_train_df.to_csv("C:/Users/nikhil/deep_learning/keras/train_scaled.csv", index=False)
scaled_test_df.to_csv("C:/Users/nikhil/deep_learning/keras/test_scaled.csv", index=False)

##########################################################


training_data_df = pd.read_csv("train_scaled.csv")

X = training_data_df.drop('total_earnings', axis=1).values
Y = training_data_df[['total_earnings']].values

# Define the model
model = Sequential()
model.add(Dense(50, input_dim=9, activation='relu'))
model.add(Dense(100, activation='relu'))
model.add(Dense(50, activation='relu'))
model.add(Dense(1, activation='linear'))
model.compile(loss='mean_squared_error', optimizer='adam')

# Train the model
model.fit(
    X,
    Y,
    epochs=50,
    shuffle=True,
    verbose=2
)

# Load the separate test data set
test_data_df = pd.read_csv("test_scaled.csv")

X_test = test_data_df.drop('total_earnings', axis=1).values
Y_test = test_data_df[['total_earnings']].values

test_error_rate = model.evaluate(X_test, Y_test, verbose=0)
print("The mean squared error (MSE) for the test data set is: {}".format(test_error_rate))

# Save the model to disk
model.save("trained_model.h5")
print("Model saved to disk.")


