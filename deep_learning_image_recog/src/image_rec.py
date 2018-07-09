import numpy as np
from keras.preprocessing  import image
from keras.applications import resnet50
import matplotlib.pyplot as plt

model = resnet50.ResNet50()

img = image.load_img("C:/Users/nikhil.deshmukh/PycharmProjects/deep_learning/hd.jpg", target_size=(224, 224))
#img= np.random.rand(224,224,3)
#plt.imshow(img)
#plt.show()

x = image.img_to_array(img)

# Add a forth dimension since Keras expects a list of images
x = np.expand_dims(x, axis=0)

# Scale the input image to the range used in the trained network
x = resnet50.preprocess_input(x)

predictions = model.predict(x)

predicted_classes = resnet50.decode_predictions(predictions, top=5)

print("This is an image of:")

for imagenet_id, name, likelihood in predicted_classes[0]:
    print(" - {}: {:2f} likelihood".format(name, likelihood))

