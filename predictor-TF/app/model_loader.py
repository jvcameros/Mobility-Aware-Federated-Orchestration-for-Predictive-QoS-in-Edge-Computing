import tensorflow as tf
import joblib

def expand_dims_layer(x):
    return tf.expand_dims(x, axis=1)

def squeeze_layer(x):
    return tf.squeeze(x, axis=1)

model = tf.keras.models.load_model(
    'app/location_prediction_model_seq2seq_fixed.keras',
    custom_objects={
        'expand_dims_layer': expand_dims_layer,
        'squeeze_layer': squeeze_layer
    },
    safe_mode=False
)

scaler = joblib.load('app/y_scaler.pkl')
